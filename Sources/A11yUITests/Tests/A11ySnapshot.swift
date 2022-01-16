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
        var nameThisFile: String
        var version: Double
        var generated: Date
        let snapshot: [A11yElement.CodableElement]

        init(snapshots: [A11yElement.CodableElement], fileName: String) {
            nameThisFile = fileName
            snapshot = snapshots
            version = A11yElement.CodableElement.version
            generated = Date()
        }
    }

    private let forbiddenCharacters: [Character] = ["(", ")",]

    private var calledInFunction = 0
    private var currentFunction = ""
    private var test: XCTestCase?
    private var fileName: String {
        var fileName = "\(currentFunction)-\(calledInFunction)"
        fileName.removeAll(where: { forbiddenCharacters.contains($0) })
        fileName = fileName.replacingOccurrences(of: "_", with: "-")
        return fileName
    }
    private let fileExtension = "json"

    private let fileManager = FileManager.default

    public init() {}

    public func a11ySnapshot(from test: XCTestCase, testName: StaticString = #function, suiteName: StaticString = #file, line: UInt = #line) {
        let elements = XCUIApplication()
            .descendants(matching: .any)
            .allElementsBoundByAccessibilityElement
            .map { A11yElement($0) }

        makeSnapshot(screen: elements, testName: String(testName), suiteName: suiteName, test: test)
    }

    private func makeSnapshot(screen: [A11yElement], testName: String, suiteName: StaticString, test: XCTestCase, line: UInt = #line) {

        if currentFunction == testName {
            calledInFunction += 1
        } else {
            calledInFunction = 0
            currentFunction = testName
        }

        self.test = test

        let snapshot = SnapshotWrapper(snapshots: screen.compactMap { $0.codable }, fileName: fileName)

        let path = Bundle(for: type(of: test)).bundleURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)

        if let data = try? Data(contentsOf: path),
           let referenceScreen = try? JSONDecoder().decode(SnapshotWrapper.self, from: data) {

            compareScreens(referenceScreen, snapshot)

        } else {
            createNewSnapshot(snapshot)
            XCTFail("No reference snapshot. Generated new snapshot.",
                    file: suiteName,
                    line: line)
        }
    }

    private func createNewSnapshot(_ snapshot: SnapshotWrapper) {
        do {
            guard let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                              in: .userDomainMask).first,
                  let test = test else {
                      // TODO: add file & line
                      XCTFail("Unable to create new snapshot")
                      return
                  }

            do {
                let jsonData = try JSONEncoder().encode(snapshot)
                let documentPath = documentDirectory.appendingPathComponent("\(fileName).json")
                try jsonData.write(to: documentPath)

                let attachment = XCTAttachment(contentsOfFile: documentPath)
                test.add(attachment)
            } catch {
                // TODO: add file & line
                XCTFail("Unable to generate new snapshot.")
            }
        }
        // TODO: Report success/failure
    }

    private func compareScreens(_ screen1: SnapshotWrapper, _ screen2: SnapshotWrapper) {

        if screen1.version < A11yElement.CodableElement.version {
            createNewSnapshot(screen2)
            XCTFail("Reference snapshot is older version. Generated new snapshot.")
        }

        // TODO: make failure reports more useful
        for i in 0..<screen1.snapshot.count {
            XCTAssertEqual(screen1.snapshot[i].label, screen2.snapshot[i].label)
            XCTAssertEqual(screen1.snapshot[i].frame, screen2.snapshot[i].frame)
            XCTAssertEqual(screen1.snapshot[i].type, screen2.snapshot[i].type)
            XCTAssertEqual(screen1.snapshot[i].traits, screen2.snapshot[i].traits)
            XCTAssertEqual(screen1.snapshot[i].enabled, screen2.snapshot[i].enabled)
        }
    }
}
