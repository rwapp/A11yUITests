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
        return fileName
    }
    private let fileExtension = "json"

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

        let path = Bundle(for: type(of: test)).bundleURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)

        if let data = try? Data(contentsOf: path),
           let referenceScreen = try? JSONDecoder().decode(SnapshotWrapper.self, from: data) {
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
            let jsonData = try JSONEncoder().encode(snapshot)

            do {
                let documentPath = documentDirectory.appendingPathComponent("\(fileName).json")
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
                           Failure.failure.report("Label does not match reference snapshot. Reference: \(referenceElement.label). Snapshot: \(snapshotElementLabel)"),
                           file: file, line: line)

            XCTAssertEqual(referenceElement.frame, snapshotElement.frame,
                           Failure.failure.report("Frame does not match reference snapshot. Reference: \(referenceElement.frame). Snapshot: \(snapshotElement.frame). Element name: \(snapshotElementLabel)"),
                           file: file, line: line)

            XCTAssertEqual(referenceElement.type, snapshotElement.type,
                           Failure.failure.report("Type does not match reference snapshot. Reference: \(referenceElement.type). Snapshot: \(snapshotElement.type). Element name: \(snapshotElementLabel)"),
                           file: file, line: line)

            XCTAssertEqual(referenceElement.traits, snapshotElement.traits,
                           Failure.failure.report("Traits do not match reference snapshot. Reference: \(referenceElement.traits.joined(separator: ", ")). Snapshot: \(snapshotElement.traits.joined(separator: ", ")). Element name: \(snapshotElementLabel)"),
                           file: file, line: line)

            XCTAssertEqual(referenceElement.enabled, snapshotElement.enabled,
                           Failure.failure.report("Enabled status does not match reference snapshot. Reference: \(referenceElement.enabled). Snapshot: \(snapshotElement.enabled). Element name: \(snapshotElementLabel)"),
                           file: file, line: line)
        }
    }
}
