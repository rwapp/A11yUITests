//
//  Snapshot.swift
//  A11yUITests
//
//  Created by Rob Whitaker on 15/01/2022.
//

import Foundation
import XCTest

final public class A11ySnapshot {
    private struct SnapshotWrapper: Codable {
        private static let wrapperVersion = 1
        static let snapshotVersion = "\(SnapshotWrapper.wrapperVersion).\(A11yElement.CodableElement.version)"
        
        var filename: String
        var version: String
        var generated: Date
        let snapshot: [A11yElement.CodableElement]

        init(snapshots: [A11yElement.CodableElement], fileName: String) {
            filename = fileName
            snapshot = snapshots
            version = SnapshotWrapper.snapshotVersion
            generated = Date()
        }
    }

    private let forbiddenCharacters: [Character] = ["(", ")",]

    private var calledInFunction = 0
    private var currentFunction = ""
    private var fileName: String {
        var fileName = "\(currentFunction)-\(calledInFunction)"
        fileName.removeAll(where: { forbiddenCharacters.contains($0) })
        fileName = fileName.replacingOccurrences(of: "_", with: "-")
        fileName.append(".json")
        return fileName
    }

    private let fileManager = FileManager.default

    public init() {}

    public func a11ySnapshot(from test: XCTestCase,
                             testName: StaticString = #function,
                             suiteName: StaticString = #file,
                             line: UInt = #line) {
        let elements = XCUIApplication()
            .descendants(matching: .any)
            .allElementsBoundByAccessibilityElement
            .map { A11yElement($0) }

        makeSnapshot(screen: elements,
                     testName: String(testName),
                     suiteName: suiteName,
                     test: test,
                     line: line)
    }

    private func makeSnapshot(screen: [A11yElement],
                              testName: String,
                              suiteName: StaticString,
                              test: XCTestCase,
                              line: UInt) {

        if currentFunction == testName {
            calledInFunction += 1
        } else {
            calledInFunction = 0
            currentFunction = testName
        }

        let snapshot = SnapshotWrapper(snapshots: screen.compactMap { $0.codable }, fileName: fileName)

        let path = Bundle(for: type(of: test)).bundleURL.appendingPathComponent(fileName)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        if let data = try? Data(contentsOf: path),
           let referenceScreen = try? decoder.decode(SnapshotWrapper.self, from: data) {
            compareScreens(reference: referenceScreen, snapshot: snapshot, test: test, file: suiteName, line: line)

        } else {
            if let docPath = createNewSnapshot(snapshot, test: test, file: suiteName, line: line) {
                XCTFail(Failure.warning.report("No reference snapshot. Generated new snapshot.\nCheck test report or \(docPath)"),
                        file: suiteName,
                        line: line)

                return
            }

            XCTFail(Failure.failure.report("No reference snapshot. Unable to create new reference."),
                    file: suiteName,
                    line: line)
        }
    }

    private func createNewSnapshot(_ snapshot: SnapshotWrapper,
                                   test: XCTestCase,
                                   file: StaticString,
                                   line: UInt) -> URL? {
        guard let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                       in: .userDomainMask).first else {
            XCTFail(Failure.failure.report("Unable get documents directory."),
                    file: file, line: line)
            return nil
        }

        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            encoder.dateEncodingStrategy = .iso8601
            let jsonData = try encoder.encode(snapshot)

            do {
                let documentPath = documentDirectory.appendingPathComponent(fileName)
                try jsonData.write(to: documentPath)

                let attachment = XCTAttachment(contentsOfFile: documentPath)
                test.add(attachment)

                return documentPath

            } catch {
                XCTFail(Failure.failure.report("Unable to write snapshot to disk."))
                return nil
            }

        } catch {
            XCTFail(Failure.failure.report("Unable to encode snapshot."))
            return nil
        }
    }

    private func compareScreens(reference: SnapshotWrapper,
                                snapshot: SnapshotWrapper,
                                test: XCTestCase,
                                file: StaticString,
                                line: UInt) {

        if reference.version < SnapshotWrapper.snapshotVersion {
            if let docPath = createNewSnapshot(snapshot, test: test, file: file, line: line) {
                XCTFail(Failure.warning.report("Reference snapshot is outdated. Generated new snapshot. Check for regressions before replacing as reference.\nCheck test report or \(docPath)"),
                        file: file,
                        line: line)

                return
            }

            XCTFail(Failure.failure.report("Reference snapshot is outdated. Unable to create new reference."),
                    file: file,
                    line: line)
            return
        }

        for i in 0..<reference.snapshot.count {

            let snapshotElement = snapshot.snapshot[i]
            let referenceElement = reference.snapshot[i]
            let snapshotElementLabel = snapshotElement.label

            XCTAssertEqual(referenceElement.label, snapshotElementLabel,
                           Failure.failure.report("Label does not match reference snapshot.\nReference: \(referenceElement.label). Snapshot: \(snapshotElementLabel)"),
                           file: file, line: line)

            XCTAssertEqual(referenceElement.type, snapshotElement.type,
                           Failure.failure.report("Type does not match reference snapshot.\nReference: \(referenceElement.type). Snapshot: \(snapshotElement.type). Element name: \(snapshotElementLabel)"),
                           file: file, line: line)

            XCTAssertEqual(referenceElement.traits, snapshotElement.traits,
                           Failure.failure.report("Traits do not match reference snapshot.\nReference: \(referenceElement.traits.joined(separator: ", ")). Snapshot: \(snapshotElement.traits.joined(separator: ", ")). Element name: \(snapshotElementLabel)"),
                           file: file, line: line)

            XCTAssertEqual(referenceElement.enabled, snapshotElement.enabled,
                           Failure.failure.report("Enabled status does not match reference snapshot.\nReference: \(referenceElement.enabled). Snapshot: \(snapshotElement.enabled). Element name: \(snapshotElementLabel)"),
                           file: file, line: line)

            compareFrame(reference: referenceElement.frame, snapshot: snapshotElement.frame, label: snapshotElementLabel, file: file, line: line)
        }
    }

    private func compareFrame(reference: CGRect, snapshot: CGRect, label: String, file: StaticString, line: UInt) {

        let refX = reference.origin.x
        let refY = reference.origin.y
        let refWidth = reference.size.width
        let refHeight = reference.size.height

        let snapX = snapshot.origin.x
        let snapY = snapshot.origin.y
        let snapWidth = snapshot.size.width
        let snapHeight = snapshot.size.height

        XCTAssertEqual(refX, snapX, accuracy: A11yValues.floatComparisonTolerance,
                       Failure.failure.report("Frame does not match reference snapshot.\nReference x: \(refX). Snapshot x: \(snapX). Element name: \(label)"),
                       file: file, line: line)

        XCTAssertEqual(refY, snapY, accuracy: A11yValues.floatComparisonTolerance,
                       Failure.failure.report("Frame does not match reference snapshot.\nReference y: \(refY). Snapshot y: \(snapY). Element name: \(label)"),
                       file: file, line: line)

        XCTAssertEqual(refWidth, snapWidth, accuracy: A11yValues.floatComparisonTolerance,
                       Failure.failure.report("Frame does not match reference snapshot.\nReference width: \(refWidth). Snapshot width: \(snapWidth). Element name: \(label)"),
                       file: file, line: line)

        XCTAssertEqual(refHeight, snapHeight, accuracy: A11yValues.floatComparisonTolerance,
                       Failure.failure.report("Frame does not match reference snapshot.\nReference height: \(refHeight). Snapshot height: \(snapHeight). Element name: \(label)"),
                       file: file, line: line)
    }
}
