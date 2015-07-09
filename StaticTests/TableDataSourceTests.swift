import XCTest
import UIKit
import Static

class TableDataSourceTests: XCTestCase {

    // MARK: - Properties

    let tableView = UITableView()
    let dataSource = TableDataSource()


    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        dataSource.tableView = tableView
    }


    // MARK: - Tests

    func testNumberOfThings() {
        XCTAssertEqual(0, tableView.numberOfSections)

        dataSource.sections = [
            Section(rows: [Row(text: "Row")]),
            Section(rows: [Row(text: "Row"), Row(text: "Row")])
        ]
        XCTAssertEqual(2, tableView.numberOfSections)
        XCTAssertEqual(1, tableView.numberOfRowsInSection(0))
        XCTAssertEqual(2, tableView.numberOfRowsInSection(1))

        dataSource.sections = [
            Section(rows: [Row(text: "Your"), Row(text: "Boat")]),
            Section(rows: [Row(text: "Gently"), Row(text: "Down"), Row(text: "The"), Row(text: "Stream")]),
            Section(rows: [Row(text: "Merrily"), Row(text: "Merrily")])
        ]
        XCTAssertEqual(3, tableView.numberOfSections)
        XCTAssertEqual(2, tableView.numberOfRowsInSection(0))
        XCTAssertEqual(4, tableView.numberOfRowsInSection(1))
        XCTAssertEqual(2, tableView.numberOfRowsInSection(2))

        dataSource.sections = []
        XCTAssertEqual(0, tableView.numberOfSections)
    }

    func testCellForRowAtIndexPath() {
        dataSource.sections = [
            Section(rows: [Row(text: "Merrily", detailText: "merrily", accessory: .DisclosureIndicator)])
        ]
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))!
        XCTAssertEqual("Merrily", cell.textLabel!.text!)
        XCTAssertEqual("merrily", cell.detailTextLabel!.text!)
        XCTAssertEqual(.DisclosureIndicator, cell.accessoryType)
    }

    func testExtremities() {
        dataSource.sections = [
            Section(header: "Head", rows: [Row(text: "and")], footer: "shoulders"),
            Section(header: "Knees", rows: [Row(text: "and")]),
            Section(rows: [Row(text: "and")], footer: "toes")
        ]

        XCTAssertEqual("Head", dataSource.tableView(tableView, titleForHeaderInSection: 0)!)
        XCTAssertEqual("shoulders", dataSource.tableView(tableView, titleForFooterInSection: 0)!)
        XCTAssertEqual("Knees", dataSource.tableView(tableView, titleForHeaderInSection: 1)!)
        XCTAssertEqual("toes", dataSource.tableView(tableView, titleForFooterInSection: 2)!)
    }

    func testHighlight() {
        dataSource.sections = [
            Section(rows: [Row(text: "Cookies")])
        ]
        XCTAssertFalse(dataSource.tableView(tableView, shouldHighlightRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)))

        dataSource.sections = [
            Section(rows: [Row(text: "Cupcakes", selection: {})])
        ]
        XCTAssertTrue(dataSource.tableView(tableView, shouldHighlightRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)))
    }

    func testSelection() {
        let expectation = expectationWithDescription("Selected")
        let selection = {
            expectation.fulfill()
        }

        dataSource.sections = [
            Section(rows: [Row(text: "Button", selection: selection)])
        ]
        dataSource.tableView(tableView, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testChangeTableView() {
        XCTAssertEqual(dataSource, tableView.dataSource as! TableDataSource)
        XCTAssertEqual(dataSource, tableView.delegate as! TableDataSource)

        let tableView2 = UITableView()
        dataSource.tableView = tableView2

        XCTAssertNil(tableView.dataSource)
        XCTAssertNil(tableView.delegate)
        XCTAssertEqual(dataSource, tableView2.dataSource as! TableDataSource)
        XCTAssertEqual(dataSource, tableView2.delegate as! TableDataSource)
    }
}