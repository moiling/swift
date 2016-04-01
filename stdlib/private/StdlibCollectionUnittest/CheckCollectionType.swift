//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import StdlibUnittest

public struct SubscriptRangeTest {
  public let expected: [OpaqueValue<Int>]
  public let collection: [OpaqueValue<Int>]
  public let bounds: Range<Int>
  public let count: Int
  public let loc: SourceLoc

  public var isEmpty: Bool { return count == 0 }

  public func bounds<C : Collection>(in c: C) -> Range<C.Index> {
    let i = c.startIndex
    return c.index(numericCast(bounds.lowerBound), stepsFrom: i) ..<
           c.index(numericCast(bounds.upperBound), stepsFrom: i)
  }

  public init(
    expected: [Int], collection: [Int], bounds: Range<Int>,
    count: Int,
    file: String = #file, line: UInt = #line
  ) {
    self.expected = expected.map(OpaqueValue.init)
    self.collection = collection.map(OpaqueValue.init)
    self.bounds = bounds
    self.count = count
    self.loc = SourceLoc(file, line, comment: "test data")
  }
}

public struct PrefixThroughTest {
  public var collection: [Int]
  public let position: Int
  public let expected: [Int]
  public let loc: SourceLoc

  init(
    collection: [Int], position: Int, expected: [Int],
    file: String = #file, line: UInt = #line
  ) {
    self.collection = collection
    self.position = position
    self.expected = expected
    self.loc = SourceLoc(file, line, comment: "prefix(through:) test data")
  }
}

public struct PrefixUpToTest {
  public var collection: [Int]
  public let end: Int
  public let expected: [Int]
  public let loc: SourceLoc

  public init(
    collection: [Int], end: Int, expected: [Int],
    file: String = #file, line: UInt = #line
  ) {
    self.collection = collection
    self.end = end
    self.expected = expected
    self.loc = SourceLoc(file, line, comment: "prefix(upTo:) test data")
  }
}

internal struct RemoveFirstNTest {
  let collection: [Int]
  let numberToRemove: Int
  let expectedCollection: [Int]
  let loc: SourceLoc

  init(
    collection: [Int], numberToRemove: Int, expectedCollection: [Int],
    file: String = #file, line: UInt = #line
  ) {
    self.collection = collection
    self.numberToRemove = numberToRemove
    self.expectedCollection = expectedCollection
    self.loc = SourceLoc(file, line, comment: "removeFirst(n: Int) test data")
  }
}

public struct SuffixFromTest {
  public var collection: [Int]
  public let start: Int
  public let expected: [Int]
  public let loc: SourceLoc

  init(
    collection: [Int], start: Int, expected: [Int],
    file: String = #file, line: UInt = #line
  ) {
    self.collection = collection
    self.start = start
    self.expected = expected
    self.loc = SourceLoc(file, line, comment: "suffix(from:) test data")
  }
}

public let subscriptRangeTests = [
  // Slice an empty collection.
  SubscriptRangeTest(
    expected: [],
    collection: [],
    bounds: 0..<0,
    count: 0),

  // Slice to the full extent.
  SubscriptRangeTest(
    expected: [ 1010 ],
    collection: [ 1010 ],
    bounds: 0..<1,
    count: 1),
  SubscriptRangeTest(
    expected: [ 1010, 2020, 3030 ],
    collection: [ 1010, 2020, 3030 ],
    bounds: 0..<3,
    count: 3),
  SubscriptRangeTest(
    expected: [ 1010, 2020, 3030, 4040, 5050 ],
    collection: [ 1010, 2020, 3030, 4040, 5050 ],
    bounds: 0..<5,
    count: 5),

  // Slice an empty prefix.
  SubscriptRangeTest(
    expected: [],
    collection: [ 1010, 2020, 3030 ],
    bounds: 0..<0,
    count: 3),

  // Slice a prefix.
  SubscriptRangeTest(
    expected: [ 1010, 2020 ],
    collection: [ 1010, 2020, 3030 ],
    bounds: 0..<2,
    count: 3),
  SubscriptRangeTest(
    expected: [ 1010, 2020 ],
    collection: [ 1010, 2020, 3030, 4040, 5050 ],
    bounds: 0..<2,
    count: 5),

  // Slice an empty suffix.
  SubscriptRangeTest(
    expected: [],
    collection: [ 1010, 2020, 3030 ],
    bounds: 3..<3,
    count: 3),

  // Slice a suffix.
  SubscriptRangeTest(
    expected: [ 2020, 3030 ],
    collection: [ 1010, 2020, 3030 ],
    bounds: 1..<3,
    count: 3),
  SubscriptRangeTest(
    expected: [ 4040, 5050 ],
    collection: [ 1010, 2020, 3030, 4040, 5050 ],
    bounds: 3..<5,
    count: 5),

  // Slice an empty range in the middle.
  SubscriptRangeTest(
    expected: [],
    collection: [ 1010, 2020, 3030 ],
    bounds: 1..<1,
    count: 3),
  SubscriptRangeTest(
    expected: [],
    collection: [ 1010, 2020, 3030 ],
    bounds: 2..<2,
    count: 3),

  // Slice the middle part.
  SubscriptRangeTest(
    expected: [ 2020 ],
    collection: [ 1010, 2020, 3030 ],
    bounds: 1..<2,
    count: 3),
  SubscriptRangeTest(
    expected: [ 3030 ],
    collection: [ 1010, 2020, 3030, 4040 ],
    bounds: 3..<4,
    count: 4),
  SubscriptRangeTest(
    expected: [ 2020, 3030, 4040 ],
    collection: [ 1010, 2020, 3030, 4040, 5050, 6060 ],
    bounds: 1..<4,
    count: 6),
]

public let prefixUpToTests = [
  PrefixUpToTest(
    collection: [],
    end: 0,
    expected: []
  ),
  PrefixUpToTest(
    collection: [1010, 2020, 3030, 4040, 5050],
    end: 3,
    expected: [1010, 2020, 3030]
  ),
  PrefixUpToTest(
    collection: [1010, 2020, 3030, 4040, 5050],
    end: 5,
    expected: [1010, 2020, 3030, 4040, 5050]
  ),
]

public let prefixThroughTests = [
  PrefixThroughTest(
    collection: [1010, 2020, 3030, 4040, 5050],
    position: 0,
    expected: [1010]
  ),
  PrefixThroughTest(
    collection: [1010, 2020, 3030, 4040, 5050],
    position: 2,
    expected: [1010, 2020, 3030]
  ),
  PrefixThroughTest(
    collection: [1010, 2020, 3030, 4040, 5050],
    position: 4,
    expected: [1010, 2020, 3030, 4040, 5050]
  ),
]

public let suffixFromTests = [
  SuffixFromTest(
    collection: [],
    start: 0,
    expected: []
  ),
  SuffixFromTest(
    collection: [1010, 2020, 3030, 4040, 5050],
    start: 0,
    expected: [1010, 2020, 3030, 4040, 5050]
  ),
  SuffixFromTest(
    collection: [1010, 2020, 3030, 4040, 5050],
    start: 3,
    expected: [4040, 5050]
  ),
  SuffixFromTest(
    collection: [1010, 2020, 3030, 4040, 5050],
    start: 5,
    expected: []
  ),
]

let removeFirstTests: [RemoveFirstNTest] = [
  RemoveFirstNTest(
    collection: [1010],
    numberToRemove: 0,
    expectedCollection: [1010]
  ),
  RemoveFirstNTest(
    collection: [1010],
    numberToRemove: 1,
    expectedCollection: []
  ),
  RemoveFirstNTest(
    collection: [1010, 2020, 3030, 4040, 5050],
    numberToRemove: 0,
    expectedCollection: [1010, 2020, 3030, 4040, 5050]
  ),
  RemoveFirstNTest(
    collection: [1010, 2020, 3030, 4040, 5050],
    numberToRemove: 1,
    expectedCollection: [2020, 3030, 4040, 5050]
  ),
  RemoveFirstNTest(
    collection: [1010, 2020, 3030, 4040, 5050],
    numberToRemove: 2,
    expectedCollection: [3030, 4040, 5050]
  ),
  RemoveFirstNTest(
    collection: [1010, 2020, 3030, 4040, 5050],
    numberToRemove: 3,
    expectedCollection: [4040, 5050]
  ),
  RemoveFirstNTest(
    collection: [1010, 2020, 3030, 4040, 5050],
    numberToRemove: 4,
    expectedCollection: [5050]
  ),
  RemoveFirstNTest(
    collection: [1010, 2020, 3030, 4040, 5050],
    numberToRemove: 5,
    expectedCollection: []
  ),
]

internal func _allIndices<C : Collection>(
  into c: C, in bounds: Range<C.Index>
) -> [C.Index] {
  var result: [C.Index] = []
  var i = bounds.lowerBound
  while i != bounds.upperBound {
    result.append(i)
    i = c.successor(of: i)
  }
  return result
}

internal enum _SubSequenceSubscriptOnIndexMode {
  case inRange
  case outOfRangeToTheLeft
  case outOfRangeToTheRight
  case baseEndIndex
  case sliceEndIndex

  static var all: [_SubSequenceSubscriptOnIndexMode] {
    return [
      .inRange,
      .outOfRangeToTheLeft,
      .outOfRangeToTheRight,
      .baseEndIndex,
      .sliceEndIndex,
    ]
  }
}

internal enum _SubSequenceSubscriptOnRangeMode {
  case inRange
  case outOfRangeToTheLeftEmpty
  case outOfRangeToTheLeftNonEmpty
  case outOfRangeToTheRightEmpty
  case outOfRangeToTheRightNonEmpty
  case outOfRangeBothSides
  case baseEndIndex

  static var all: [_SubSequenceSubscriptOnRangeMode] {
    return [
      .inRange,
      .outOfRangeToTheLeftEmpty,
      .outOfRangeToTheLeftNonEmpty,
      .outOfRangeToTheRightEmpty,
      .outOfRangeToTheRightNonEmpty,
      .outOfRangeBothSides,
      .baseEndIndex,
    ]
  }
}

extension TestSuite {
  public func addCollectionTests<
    C : Collection,
    CollectionWithEquatableElement : Collection
    where
    C.SubSequence : Collection,
    C.SubSequence.Iterator.Element == C.Iterator.Element,
    C.SubSequence.Index == C.Index,
    C.SubSequence.Indices.Iterator.Element == C.Index,
    C.SubSequence.SubSequence == C.SubSequence,
    C.Indices : Collection,
    C.Indices.Iterator.Element == C.Index,
    C.Indices.Index == C.Index,
    C.Indices.SubSequence == C.Indices,
    CollectionWithEquatableElement.Iterator.Element : Equatable
  >(
    testNamePrefix: String = "",
    makeCollection: ([C.Iterator.Element]) -> C,
    wrapValue: (OpaqueValue<Int>) -> C.Iterator.Element,
    extractValue: (C.Iterator.Element) -> OpaqueValue<Int>,

    makeCollectionOfEquatable: ([CollectionWithEquatableElement.Iterator.Element]) -> CollectionWithEquatableElement,
    wrapValueIntoEquatable: (MinimalEquatableValue) -> CollectionWithEquatableElement.Iterator.Element,
    extractValueFromEquatable: ((CollectionWithEquatableElement.Iterator.Element) -> MinimalEquatableValue),

    checksAdded: Box<Set<String>> = Box([]),
    resiliencyChecks: CollectionMisuseResiliencyChecks = .all,
    outOfBoundsIndexOffset: Int = 1,
    outOfBoundsSubscriptOffset: Int = 1
  ) {
    var testNamePrefix = testNamePrefix

    if checksAdded.value.contains(#function) {
      return
    }
    checksAdded.value.insert(#function)

    addSequenceTests(
      testNamePrefix,
      makeSequence: makeCollection,
      wrapValue: wrapValue,
      extractValue: extractValue,
      makeSequenceOfEquatable: makeCollectionOfEquatable,
      wrapValueIntoEquatable: wrapValueIntoEquatable,
      extractValueFromEquatable: extractValueFromEquatable,
      checksAdded: checksAdded,
      resiliencyChecks: resiliencyChecks)

    func makeWrappedCollection(elements: [OpaqueValue<Int>]) -> C {
      return makeCollection(elements.map(wrapValue))
    }

    func makeWrappedCollectionWithEquatableElement(
      elements: [MinimalEquatableValue]
    ) -> CollectionWithEquatableElement {
      return makeCollectionOfEquatable(elements.map(wrapValueIntoEquatable))
    }

    testNamePrefix += String(C.Type)

//===----------------------------------------------------------------------===//
// generate()
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).generate()/semantics") {
  for test in subscriptRangeTests {
    let c = makeWrappedCollection(test.collection)
    for _ in 0..<3 {
      checkSequence(
        test.collection.map(wrapValue),
        c,
        resiliencyChecks: .none) {
        extractValue($0).value == extractValue($1).value
      }
    }
  }
}

//===----------------------------------------------------------------------===//
// Index
//===----------------------------------------------------------------------===//

if resiliencyChecks.creatingOutOfBoundsIndicesBehavior != .none {
  self.test("\(testNamePrefix).Index/OutOfBounds/Right/NonEmpty") {
    let c = makeWrappedCollection([ 1010, 2020, 3030 ].map(OpaqueValue.init))
    let index = c.endIndex
    if resiliencyChecks.creatingOutOfBoundsIndicesBehavior == .trap {
      expectCrashLater()
      _blackHole(c.index(numericCast(outOfBoundsIndexOffset), stepsFrom: index))
    } else {
      expectFailure {
        _blackHole(c.index(numericCast(outOfBoundsIndexOffset), stepsFrom: index))
      }
    }
  }

  self.test("\(testNamePrefix).Index/OutOfBounds/Right/Empty") {
    let c = makeWrappedCollection([])
    let index = c.endIndex
    if resiliencyChecks.creatingOutOfBoundsIndicesBehavior == .trap {
      expectCrashLater()
      _blackHole(c.index(numericCast(outOfBoundsIndexOffset), stepsFrom: index))
    } else {
      expectFailure {
        _blackHole(c.index(numericCast(outOfBoundsIndexOffset), stepsFrom: index))
      }
    }
  }
}

//===----------------------------------------------------------------------===//
// subscript(_: Index)
//===----------------------------------------------------------------------===//

if resiliencyChecks.subscriptOnOutOfBoundsIndicesBehavior != .none {
  self.test("\(testNamePrefix).subscript(_: Index)/OutOfBounds/Right/NonEmpty/Get") {
    let c = makeWrappedCollection([ 1010, 2020, 3030 ].map(OpaqueValue.init))
    var index = c.endIndex
    if resiliencyChecks.subscriptOnOutOfBoundsIndicesBehavior == .trap {
      expectCrashLater()
      index = c.index(numericCast(outOfBoundsSubscriptOffset), stepsFrom: index)
      _blackHole(c[index])
    } else {
      expectFailure {
        index = c.index(numericCast(outOfBoundsSubscriptOffset), stepsFrom: index)
        _blackHole(c[index])
      }
    }
  }

  self.test("\(testNamePrefix).subscript(_: Index)/OutOfBounds/Right/Empty/Get") {
    let c = makeWrappedCollection([])
    var index = c.endIndex
    if resiliencyChecks.subscriptOnOutOfBoundsIndicesBehavior == .trap {
      expectCrashLater()
      index = c.index(numericCast(outOfBoundsSubscriptOffset), stepsFrom: index)
      _blackHole(c[index])
    } else {
      expectFailure {
        index = c.index(numericCast(outOfBoundsSubscriptOffset), stepsFrom: index)
        _blackHole(c[index])
      }
    }
  }

  func testSubSequenceSubscriptOnIndex(
    elements: [OpaqueValue<Int>], bounds: Range<Int>
  ) {
    let sliceFromLeft = bounds.lowerBound
    let sliceFromRight = elements.count - bounds.upperBound

    for mode in _SubSequenceSubscriptOnIndexMode.all {
      self.test("\(testNamePrefix).SubSequence.subscript(_: Index)/Get/\(mode)/\(elements)/sliceFromLeft=\(sliceFromLeft)/sliceFromRight=\(sliceFromRight)") {
        let base = makeWrappedCollection(elements)
        let sliceStartIndex =
          base.index(numericCast(sliceFromLeft), stepsFrom: base.startIndex)
        let sliceEndIndex = base.index(
          numericCast(elements.count - sliceFromRight),
          stepsFrom: base.startIndex)
        var slice = base[sliceStartIndex..<sliceEndIndex]
        expectType(C.SubSequence.self, &slice)

        var index: C.Index = base.startIndex
        switch mode {
        case .inRange:
          let sliceNumericIndices =
            sliceFromLeft..<(elements.count - sliceFromRight)
          for (i, index) in base.indices.enumerated() {
            if sliceNumericIndices.contains(i) {
              expectEqual(
                elements[i].value,
                extractValue(slice[index]).value)
              expectEqual(
                extractValue(base[index]).value,
                extractValue(slice[index]).value)
            }
          }
          return
        case .outOfRangeToTheLeft:
          if sliceFromLeft == 0 { return }
          index = base.index(
            numericCast(sliceFromLeft - 1),
            stepsFrom: base.startIndex)
        case .outOfRangeToTheRight:
          if sliceFromRight == 0 { return }
          index = base.index(
            numericCast(elements.count - sliceFromRight),
            stepsFrom: base.startIndex)
        case .baseEndIndex:
          index = base.endIndex
        case .sliceEndIndex:
          index = sliceEndIndex
        }

        if resiliencyChecks.subscriptOnOutOfBoundsIndicesBehavior == .trap {
          expectCrashLater()
          _blackHole(slice[index])
        } else {
          expectFailure {
            _blackHole(slice[index])
          }
        }
      }
    }
  }

  for test in subscriptRangeTests {
    testSubSequenceSubscriptOnIndex(test.collection, bounds: test.bounds)
  }
}

//===----------------------------------------------------------------------===//
// subscript(_: Range)
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).subscript(_: Range)/Get/semantics") {
  for test in subscriptRangeTests {
    let base = makeWrappedCollection(test.collection)
    let sliceBounds = test.bounds(in: base)
    let slice = base[sliceBounds]

    expectEqual(sliceBounds.lowerBound, slice.startIndex)
    expectEqual(sliceBounds.upperBound, slice.endIndex)
    /*
    // TODO: swift-3-indexing-model: uncomment the following.
    // FIXME: improve checkForwardCollection to check the SubSequence type.
    checkCollection(
      slice,
      expected: test.expected.map(wrapValue),
      resiliencyChecks: .none) {
      extractValue($0).value == extractValue($1).value
    }
    */
  }
}

if resiliencyChecks.subscriptRangeOnOutOfBoundsRangesBehavior != .none {
  self.test("\(testNamePrefix).subscript(_: Range)/OutOfBounds/Right/NonEmpty/Get") {
    let c = makeWrappedCollection([ 1010, 2020, 3030 ].map(OpaqueValue.init))
    var index = c.endIndex
    if resiliencyChecks.subscriptRangeOnOutOfBoundsRangesBehavior == .trap {
      expectCrashLater()
      index = c.index(numericCast(outOfBoundsSubscriptOffset), stepsFrom: index)
      _blackHole(c[index..<index])
    } else {
      expectFailure {
        index = c.index(numericCast(outOfBoundsSubscriptOffset), stepsFrom: index)
        _blackHole(c[index..<index])
      }
    }
  }

  self.test("\(testNamePrefix).subscript(_: Range)/OutOfBounds/Right/Empty/Get") {
    let c = makeWrappedCollection([])
    var index = c.endIndex
    if resiliencyChecks.subscriptRangeOnOutOfBoundsRangesBehavior == .trap {
      expectCrashLater()
      index = c.index(numericCast(outOfBoundsSubscriptOffset), stepsFrom: index)
      _blackHole(c[index..<index])
    } else {
      expectFailure {
        index = c.index(numericCast(outOfBoundsSubscriptOffset), stepsFrom: index)
        _blackHole(c[index..<index])
      }
    }
  }

  func testSubSequenceSubscriptOnRange(
    elements: [OpaqueValue<Int>], bounds: Range<Int>
  ) {
    let sliceFromLeft = bounds.lowerBound
    let sliceFromRight = elements.count - bounds.upperBound

    for mode in _SubSequenceSubscriptOnRangeMode.all {
      self.test("\(testNamePrefix).SubSequence.subscript(_: Range)/Get/\(mode)/\(elements)/sliceFromLeft=\(sliceFromLeft)/sliceFromRight=\(sliceFromRight)") {
        let base = makeWrappedCollection(elements)
        let sliceStartIndex =
          base.index(numericCast(sliceFromLeft), stepsFrom: base.startIndex)
        let sliceEndIndex = base.index(
          numericCast(elements.count - sliceFromRight),
          stepsFrom: base.startIndex)
        var slice = base[sliceStartIndex..<sliceEndIndex]
        expectType(C.SubSequence.self, &slice)

        var bounds: Range<C.Index> = base.startIndex..<base.startIndex
        switch mode {
        case .inRange:
          let sliceNumericIndices =
            sliceFromLeft..<(elements.count - sliceFromRight + 1)
          for (i, subSliceStartIndex) in base.indices.enumerated() {
            for (j, subSliceEndIndex) in base.indices.enumerated() {
              if i <= j &&
                sliceNumericIndices.contains(i) &&
                sliceNumericIndices.contains(j) {
                let subSlice = slice[subSliceStartIndex..<subSliceEndIndex]
                for (k, index) in subSlice.indices.enumerated() {
                  expectEqual(
                    elements[i + k].value,
                    extractValue(subSlice[index]).value)
                  expectEqual(
                    extractValue(base[index]).value,
                    extractValue(subSlice[index]).value)
                  expectEqual(
                    extractValue(slice[index]).value,
                    extractValue(subSlice[index]).value)
                }
              }
            }
          }
          return
        case .outOfRangeToTheLeftEmpty:
          if sliceFromLeft == 0 { return }
          let index = base.index(
            numericCast(sliceFromLeft - 1),
            stepsFrom: base.startIndex)
          bounds = index..<index
          break
        case .outOfRangeToTheLeftNonEmpty:
          if sliceFromLeft == 0 { return }
          let index = base.index(
            numericCast(sliceFromLeft - 1),
            stepsFrom: base.startIndex)
          bounds = index..<sliceStartIndex
          break
        case .outOfRangeToTheRightEmpty:
          if sliceFromRight == 0 { return }
          let index = base.index(
            numericCast(elements.count - sliceFromRight + 1),
            stepsFrom: base.startIndex)
          bounds = index..<index
          break
        case .outOfRangeToTheRightNonEmpty:
          if sliceFromRight == 0 { return }
          let index = base.index(
            numericCast(elements.count - sliceFromRight + 1),
            stepsFrom: base.startIndex)
          bounds = sliceEndIndex..<index
          break
        case .outOfRangeBothSides:
          if sliceFromLeft == 0 { return }
          if sliceFromRight == 0 { return }
          bounds =
            base.index(
              numericCast(sliceFromLeft - 1),
              stepsFrom: base.startIndex)
            ..<
            base.index(
              numericCast(elements.count - sliceFromRight + 1),
              stepsFrom: base.startIndex)
          break
        case .baseEndIndex:
          if sliceFromRight == 0 { return }
          bounds = sliceEndIndex..<base.endIndex
          break
        }

        if resiliencyChecks.subscriptOnOutOfBoundsIndicesBehavior == .trap {
          expectCrashLater()
          _blackHole(slice[bounds])
        } else {
          expectFailure {
            _blackHole(slice[bounds])
          }
        }
      }
    }
  }

  for test in subscriptRangeTests {
    testSubSequenceSubscriptOnRange(test.collection, bounds: test.bounds)
  }
}

// FIXME: swift-3-indexing-model - add tests for the follow?
//          successor(of: i: Index) -> Index
//          formSuccessor(i: inout Index)
//          advance(i: Index, by n: IndexDistance) -> Index
//          advance(i: Index, by n: IndexDistance, limitedBy: Index) -> Index
//          distance(from start: Index, to end: Index) -> IndexDistance
//          _failEarlyRangeCheck(index: Index, bounds: Range<Index>)
//          _failEarlyRangeCheck(range: Range<Index>, bounds: Range<Index>)

//===----------------------------------------------------------------------===//
// isEmpty
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).isEmpty/semantics") {
  for test in subscriptRangeTests {
    let c = makeWrappedCollection(test.collection)
    expectEqual(test.isEmpty, c.isEmpty)
  }
}

//===----------------------------------------------------------------------===//
// count
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).count/semantics") {
  for test in subscriptRangeTests {
    let c = makeWrappedCollection(test.collection)
    expectEqual(test.count, numericCast(c.count) as Int)
  }
}

//===----------------------------------------------------------------------===//
// index(of:)/index(where:)
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).index(of:)/semantics") {
  for test in findTests {
    let c = makeWrappedCollectionWithEquatableElement(test.sequence)
    var result = c.index(of: wrapValueIntoEquatable(test.element))
    expectType(
      Optional<CollectionWithEquatableElement.Index>.self,
      &result)
    let zeroBasedIndex = result.map {
      numericCast(c.distance(from: c.startIndex, to: $0)) as Int
    }
    expectEqual(
      test.expected,
      zeroBasedIndex,
      stackTrace: SourceLocStack().with(test.loc))
  }
}

self.test("\(testNamePrefix).index(where:)/semantics") {
  for test in findTests {
    let c = makeWrappedCollectionWithEquatableElement(test.sequence)
    let closureLifetimeTracker = LifetimeTracked(0)
    expectEqual(1, LifetimeTracked.instances)
    let result = c.index {
      (candidate) in
      _blackHole(closureLifetimeTracker)
      return extractValueFromEquatable(candidate).value == test.element.value
    }
    let zeroBasedIndex = result.map {
      numericCast(c.distance(from: c.startIndex, to: $0)) as Int
    }
    expectEqual(
      test.expected,
      zeroBasedIndex,
      stackTrace: SourceLocStack().with(test.loc))
  }
}

//===----------------------------------------------------------------------===//
// first
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).first") {
  for test in subscriptRangeTests {
    let c = makeWrappedCollection(test.collection)
    let result = c.first
    if test.isEmpty {
      expectEmpty(result)
    } else {
      expectOptionalEqual(
        test.collection[0],
        result.map(extractValue)
      ) { $0.value == $1.value }
    }
  }
}

//===----------------------------------------------------------------------===//
// indices
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).indices") {
  // TODO: swift-3-indexing-model: improve this test.  `indices` is not just a
  // `Range` anymore, it can be anything.
  for test in subscriptRangeTests {
    let c = makeWrappedCollection(test.collection)
    let indices = c.indices
    expectEqual(c.startIndex, indices.startIndex)
    expectEqual(c.endIndex, indices.endIndex)
  }
}

//===----------------------------------------------------------------------===//
// dropFirst()
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).dropFirst/semantics") {
  for test in dropFirstTests {
    let s = makeWrappedCollection(test.sequence.map(OpaqueValue.init))
    let result = s.dropFirst(test.dropElements)
    expectEqualSequence(
      test.expected, result.map(extractValue).map { $0.value },
      stackTrace: SourceLocStack().with(test.loc))
  }
}

//===----------------------------------------------------------------------===//
// dropLast()
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).dropLast/semantics") {
  for test in dropLastTests {
    let s = makeWrappedCollection(test.sequence.map(OpaqueValue.init))
    let result = s.dropLast(test.dropElements)
    expectEqualSequence(test.expected, result.map(extractValue).map { $0.value },
      stackTrace: SourceLocStack().with(test.loc))
  }
}

//===----------------------------------------------------------------------===//
// prefix()
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).prefix/semantics") {
  for test in prefixTests {
    let s = makeWrappedCollection(test.sequence.map(OpaqueValue.init))
    let result = s.prefix(test.maxLength)
    expectEqualSequence(test.expected, result.map(extractValue).map { $0.value },
      stackTrace: SourceLocStack().with(test.loc))
  }
}

//===----------------------------------------------------------------------===//
// suffix()
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).suffix/semantics") {
  for test in suffixTests {
    let s = makeWrappedCollection(test.sequence.map(OpaqueValue.init))
    let result = s.suffix(test.maxLength)
    expectEqualSequence(test.expected, result.map(extractValue).map { $0.value },
      stackTrace: SourceLocStack().with(test.loc))
  }
}

//===----------------------------------------------------------------------===//
// split()
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).split/semantics") {
  for test in splitTests {
    let s = makeWrappedCollection(test.sequence.map(OpaqueValue.init))
    let result = s.split(
      maxSplits: test.maxSplits,
      omittingEmptySubsequences: test.omittingEmptySubsequences
    ) {
      extractValue($0).value == test.separator
    }
    expectEqualSequence(test.expected, result.map {
      $0.map {
        extractValue($0).value
      }
    },
    stackTrace: SourceLocStack().with(test.loc)) { $0 == $1 }
  }
}

//===----------------------------------------------------------------------===//
// prefix(through:)
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).prefix(through:)/semantics") {
  for test in prefixThroughTests {
    let c = makeWrappedCollection(test.collection.map(OpaqueValue.init))
    let index = c.index(numericCast(test.position), stepsFrom: c.startIndex)
    let result = c.prefix(through: index)
    expectEqualSequence(test.expected, result.map(extractValue).map { $0.value },
      stackTrace: SourceLocStack().with(test.loc))
  }
}

//===----------------------------------------------------------------------===//
// prefix(upTo:)
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).prefix(upTo:)/semantics") {
  for test in prefixUpToTests {
    let c = makeWrappedCollection(test.collection.map(OpaqueValue.init))
    let index = c.index(numericCast(test.end), stepsFrom: c.startIndex)
    let result = c.prefix(upTo: index)
    expectEqualSequence(test.expected, result.map(extractValue).map { $0.value },
      stackTrace: SourceLocStack().with(test.loc))
  }
}

//===----------------------------------------------------------------------===//
// suffix(from:)
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).suffix(from:)/semantics") {
  for test in suffixFromTests {
    let c = makeWrappedCollection(test.collection.map(OpaqueValue.init))
    let index = c.index(numericCast(test.start), stepsFrom: c.startIndex)
    let result = c.suffix(from: index)
    expectEqualSequence(test.expected, result.map(extractValue).map { $0.value },
      stackTrace: SourceLocStack().with(test.loc))
  }
}

//===----------------------------------------------------------------------===//
// removeFirst()/slice
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).removeFirst()/slice/semantics") {
  for test in removeFirstTests.filter({ $0.numberToRemove == 1 }) {
    let c = makeWrappedCollection(test.collection.map(OpaqueValue.init))
    var slice = c[c.startIndex..<c.endIndex]
    let survivingIndices = _allIndices(
      into: slice,
      in: slice.successor(of: slice.startIndex)..<slice.endIndex)
    let removedElement = slice.removeFirst()
    expectEqual(test.collection.first, extractValue(removedElement).value)
    expectEqualSequence(
      test.expectedCollection,
      slice.map { extractValue($0).value },
      "removeFirst() shouldn't mutate the tail of the slice",
      stackTrace: SourceLocStack().with(test.loc)
    )
    expectEqualSequence(
      test.expectedCollection,
      survivingIndices.map { extractValue(slice[$0]).value },
      "removeFirst() shouldn't invalidate indices",
      stackTrace: SourceLocStack().with(test.loc)
    )
    expectEqualSequence(
      test.collection,
      c.map { extractValue($0).value },
      "removeFirst() shouldn't mutate the collection that was sliced",
      stackTrace: SourceLocStack().with(test.loc))
  }
}

self.test("\(testNamePrefix).removeFirst()/slice/empty/semantics") {
  let c = makeWrappedCollection(Array<OpaqueValue<Int>>())
  var slice = c[c.startIndex..<c.startIndex]
  expectCrashLater()
  _ = slice.removeFirst() // Should trap.
}

//===----------------------------------------------------------------------===//
// removeFirst(n: Int)/slice
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).removeFirst(n: Int)/slice/semantics") {
  for test in removeFirstTests {
    let c = makeWrappedCollection(test.collection.map(OpaqueValue.init))
    var slice = c[c.startIndex..<c.endIndex]
    let survivingIndices = _allIndices(
      into: slice,
      in: slice.index(numericCast(test.numberToRemove), stepsFrom: slice.startIndex) ..<
        slice.endIndex
    )
    slice.removeFirst(test.numberToRemove)
    expectEqualSequence(
      test.expectedCollection,
      slice.map { extractValue($0).value },
      "removeFirst() shouldn't mutate the tail of the slice",
      stackTrace: SourceLocStack().with(test.loc)
    )
    expectEqualSequence(
      test.expectedCollection,
      survivingIndices.map { extractValue(slice[$0]).value },
      "removeFirst() shouldn't invalidate indices",
      stackTrace: SourceLocStack().with(test.loc)
    )
    expectEqualSequence(
      test.collection,
      c.map { extractValue($0).value },
      "removeFirst() shouldn't mutate the collection that was sliced",
      stackTrace: SourceLocStack().with(test.loc))
  }
}

self.test("\(testNamePrefix).removeFirst(n: Int)/slice/empty/semantics") {
  let c = makeWrappedCollection(Array<OpaqueValue<Int>>())
  var slice = c[c.startIndex..<c.startIndex]
  expectCrashLater()
  slice.removeFirst(1) // Should trap.
}

self.test("\(testNamePrefix).removeFirst(n: Int)/slice/removeNegative/semantics") {
  let c = makeWrappedCollection([1010, 2020].map(OpaqueValue.init))
  var slice = c[c.startIndex..<c.startIndex]
  expectCrashLater()
  slice.removeFirst(-1) // Should trap.
}

self.test("\(testNamePrefix).removeFirst(n: Int)/slice/removeTooMany/semantics") {
  let c = makeWrappedCollection([1010, 2020].map(OpaqueValue.init))
  var slice = c[c.startIndex..<c.startIndex]
  expectCrashLater()
  slice.removeFirst(3) // Should trap.
}

//===----------------------------------------------------------------------===//
// popFirst()/slice
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).popFirst()/slice/semantics") {
  // This can just reuse the test data for removeFirst()
  for test in removeFirstTests.filter({ $0.numberToRemove == 1 }) {
    let c = makeWrappedCollection(test.collection.map(OpaqueValue.init))
    var slice = c[c.startIndex..<c.endIndex]
    let survivingIndices = _allIndices(
      into: slice,
      in: slice.successor(of: slice.startIndex)..<slice.endIndex)
    let removedElement = slice.popFirst()!
    expectEqual(test.collection.first, extractValue(removedElement).value)
    expectEqualSequence(
      test.expectedCollection,
      slice.map { extractValue($0).value },
      "popFirst() shouldn't mutate the tail of the slice",
      stackTrace: SourceLocStack().with(test.loc)
    )
    expectEqualSequence(
      test.expectedCollection,
      survivingIndices.map { extractValue(slice[$0]).value },
      "popFirst() shouldn't invalidate indices",
      stackTrace: SourceLocStack().with(test.loc)
    )
    expectEqualSequence(
      test.collection,
      c.map { extractValue($0).value },
      "popFirst() shouldn't mutate the collection that was sliced",
      stackTrace: SourceLocStack().with(test.loc))
  }
}

self.test("\(testNamePrefix).popFirst()/slice/empty/semantics") {
  let c = makeWrappedCollection(Array<OpaqueValue<Int>>())
  var slice = c[c.startIndex..<c.startIndex]
  expectEmpty(slice.popFirst())
}

//===----------------------------------------------------------------------===//

  } // addCollectionTests

  public func addBidirectionalCollectionTests<
    C : BidirectionalCollection,
    CollectionWithEquatableElement : BidirectionalCollection
    where
    C.SubSequence : BidirectionalCollection,
    C.SubSequence.Iterator.Element == C.Iterator.Element,
    C.SubSequence.Index == C.Index,
    C.SubSequence.Indices.Iterator.Element == C.Index,
    C.SubSequence.SubSequence == C.SubSequence,
    C.Indices : BidirectionalCollection,
    C.Indices.Iterator.Element == C.Index,
    C.Indices.Index == C.Index,
    C.Indices.SubSequence == C.Indices,
    CollectionWithEquatableElement.Iterator.Element : Equatable
  >(
    testNamePrefix: String = "",
    makeCollection: ([C.Iterator.Element]) -> C,
    wrapValue: (OpaqueValue<Int>) -> C.Iterator.Element,
    extractValue: (C.Iterator.Element) -> OpaqueValue<Int>,

    makeCollectionOfEquatable: ([CollectionWithEquatableElement.Iterator.Element]) -> CollectionWithEquatableElement,
    wrapValueIntoEquatable: (MinimalEquatableValue) -> CollectionWithEquatableElement.Iterator.Element,
    extractValueFromEquatable: ((CollectionWithEquatableElement.Iterator.Element) -> MinimalEquatableValue),

    checksAdded: Box<Set<String>> = Box([]),
    resiliencyChecks: CollectionMisuseResiliencyChecks = .all,
    outOfBoundsIndexOffset: Int = 1,
    outOfBoundsSubscriptOffset: Int = 1
  ) {
    var testNamePrefix = testNamePrefix
    if checksAdded.value.contains(#function) {
      return
    }
    checksAdded.value.insert(#function)

    addCollectionTests(
      testNamePrefix,
      makeCollection: makeCollection,
      wrapValue: wrapValue,
      extractValue: extractValue,
      makeCollectionOfEquatable: makeCollectionOfEquatable,
      wrapValueIntoEquatable: wrapValueIntoEquatable,
      extractValueFromEquatable: extractValueFromEquatable,
      checksAdded: checksAdded,
      resiliencyChecks: resiliencyChecks,
      outOfBoundsIndexOffset: outOfBoundsIndexOffset,
      outOfBoundsSubscriptOffset: outOfBoundsSubscriptOffset)

    func makeWrappedCollection(elements: [OpaqueValue<Int>]) -> C {
      return makeCollection(elements.map(wrapValue))
    }

    testNamePrefix += String(C.Type)

// FIXME: swift-3-indexing-model - add tests for the follow?
//          predecessor(of i: Index) -> Index
//          formPredecessor(i: inout Index)

// FIXME: swift-3-indexing-model - enhance the following for negative direction?
//          advance(i: Index, by n: IndexDistance) -> Index
//          advance(i: Index, by n: IndexDistance, limitedBy: Index) -> Index
//          distance(from start: Index, to end: Index) -> IndexDistance

//===----------------------------------------------------------------------===//
// last
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).last") {
  for test in subscriptRangeTests {
    let c = makeWrappedCollection(test.collection)
    let result = c.last
    if test.isEmpty {
      expectEmpty(result)
    } else {
      expectOptionalEqual(
        test.collection[test.count - 1],
        result.map(extractValue)
      ) { $0.value == $1.value }
    }
  }
}

//===----------------------------------------------------------------------===//
// removeLast()/slice
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).removeLast()/slice/semantics") {
  for test in removeLastTests.filter({ $0.numberToRemove == 1 }) {
    let c = makeWrappedCollection(test.collection)
    var slice = c[c.startIndex..<c.endIndex]
    let survivingIndices = _allIndices(
      into: slice,
      in: slice.startIndex ..<
        slice.index(numericCast(-test.numberToRemove), stepsFrom: slice.endIndex)
    )
    let removedElement = slice.removeLast()
    expectEqual(
      test.collection.last!.value,
      extractValue(removedElement).value)
    expectEqualSequence(
      test.expectedCollection,
      slice.map { extractValue($0).value },
      "removeLast() shouldn't mutate the head of the slice",
      stackTrace: SourceLocStack().with(test.loc)
    )
    expectEqualSequence(
      test.expectedCollection,
      survivingIndices.map { extractValue(slice[$0]).value },
      "removeLast() shouldn't invalidate indices",
      stackTrace: SourceLocStack().with(test.loc)
    )
    expectEqualSequence(
      test.collection.map { $0.value },
      c.map { extractValue($0).value },
      "removeLast() shouldn't mutate the collection that was sliced",
      stackTrace: SourceLocStack().with(test.loc))
  }
}

self.test("\(testNamePrefix).removeLast()/slice/empty/semantics") {
  let c = makeWrappedCollection(Array<OpaqueValue<Int>>())
  var slice = c[c.startIndex..<c.startIndex]
  expectCrashLater()
  _ = slice.removeLast() // Should trap.
}

//===----------------------------------------------------------------------===//
// removeLast(n: Int)/slice
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).removeLast(n: Int)/slice/semantics") {
  for test in removeLastTests {
    let c = makeWrappedCollection(test.collection)
    var slice = c[c.startIndex..<c.endIndex]
    let survivingIndices = _allIndices(
      into: slice,
      in: slice.startIndex ..<
        slice.index(numericCast(-test.numberToRemove), stepsFrom: slice.endIndex)
    )
    slice.removeLast(test.numberToRemove)
    expectEqualSequence(
      test.expectedCollection,
      slice.map { extractValue($0).value },
      "removeLast() shouldn't mutate the head of the slice",
      stackTrace: SourceLocStack().with(test.loc)
    )
    expectEqualSequence(
      test.expectedCollection,
      survivingIndices.map { extractValue(slice[$0]).value },
      "removeLast() shouldn't invalidate indices",
      stackTrace: SourceLocStack().with(test.loc)
    )
    expectEqualSequence(
      test.collection.map { $0.value },
      c.map { extractValue($0).value },
      "removeLast() shouldn't mutate the collection that was sliced",
      stackTrace: SourceLocStack().with(test.loc))
  }
}

self.test("\(testNamePrefix).removeLast(n: Int)/slice/empty/semantics") {
  let c = makeWrappedCollection(Array<OpaqueValue<Int>>())
  var slice = c[c.startIndex..<c.startIndex]
  expectCrashLater()
  slice.removeLast(1) // Should trap.
}

self.test("\(testNamePrefix).removeLast(n: Int)/slice/removeNegative/semantics") {
  let c = makeWrappedCollection([1010, 2020].map(OpaqueValue.init))
  var slice = c[c.startIndex..<c.startIndex]
  expectCrashLater()
  slice.removeLast(-1) // Should trap.
}

self.test("\(testNamePrefix).removeLast(n: Int)/slice/removeTooMany/semantics") {
  let c = makeWrappedCollection([1010, 2020].map(OpaqueValue.init))
  var slice = c[c.startIndex..<c.startIndex]
  expectCrashLater()
  slice.removeLast(3) // Should trap.
}

//===----------------------------------------------------------------------===//
// popLast()/slice
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).popLast()/slice/semantics") {
  // This can just reuse the test data for removeLast()
  for test in removeLastTests.filter({ $0.numberToRemove == 1 }) {
    let c = makeWrappedCollection(test.collection)
    var slice = c[c.startIndex..<c.endIndex]
    let survivingIndices = _allIndices(
      into: slice,
      in: slice.startIndex ..<
        slice.index(numericCast(-test.numberToRemove), stepsFrom: slice.endIndex)
    )
    let removedElement = slice.popLast()!
    expectEqual(
      test.collection.last!.value,
      extractValue(removedElement).value)
    expectEqualSequence(
      test.expectedCollection,
      slice.map { extractValue($0).value },
      "popLast() shouldn't mutate the head of the slice",
      stackTrace: SourceLocStack().with(test.loc)
    )
    expectEqualSequence(
      test.expectedCollection,
      survivingIndices.map { extractValue(slice[$0]).value },
      "popLast() shouldn't invalidate indices",
      stackTrace: SourceLocStack().with(test.loc)
    )
    expectEqualSequence(
      test.collection.map { $0.value },
      c.map { extractValue($0).value },
      "popLast() shouldn't mutate the collection that was sliced",
      stackTrace: SourceLocStack().with(test.loc))
  }
}

self.test("\(testNamePrefix).popLast()/slice/empty/semantics") {
  let c = makeWrappedCollection(Array<OpaqueValue<Int>>())
  var slice = c[c.startIndex..<c.startIndex]
  expectEmpty(slice.popLast())
}


//===----------------------------------------------------------------------===//
// Index
//===----------------------------------------------------------------------===//

if resiliencyChecks.creatingOutOfBoundsIndicesBehavior != .none {
  self.test("\(testNamePrefix).Index/OutOfBounds/Left/NonEmpty") {
    let c = makeWrappedCollection([ 1010, 2020, 3030 ].map(OpaqueValue.init))
    let index = c.startIndex
    if resiliencyChecks.creatingOutOfBoundsIndicesBehavior == .trap {
      expectCrashLater()
      _blackHole(c.index(numericCast(-outOfBoundsIndexOffset), stepsFrom: index))
    } else {
      expectFailure {
        _blackHole(c.index(numericCast(-outOfBoundsIndexOffset), stepsFrom: index))
      }
    }
  }

  self.test("\(testNamePrefix).Index/OutOfBounds/Left/Empty") {
    let c = makeWrappedCollection([])
    let index = c.startIndex
    if resiliencyChecks.creatingOutOfBoundsIndicesBehavior == .trap {
      expectCrashLater()
      _blackHole(c.index(numericCast(-outOfBoundsIndexOffset), stepsFrom: index))
    } else {
      expectFailure {
        _blackHole(c.index(numericCast(-outOfBoundsIndexOffset), stepsFrom: index))
      }
    }
  }
}

//===----------------------------------------------------------------------===//
// subscript(_: Index)
//===----------------------------------------------------------------------===//

if resiliencyChecks.subscriptOnOutOfBoundsIndicesBehavior != .none {
  self.test("\(testNamePrefix).subscript(_: Index)/OutOfBounds/Left/NonEmpty/Get") {
    let c = makeWrappedCollection([ 1010, 2020, 3030 ].map(OpaqueValue.init))
    var index = c.startIndex
    if resiliencyChecks.subscriptOnOutOfBoundsIndicesBehavior == .trap {
      expectCrashLater()
      index = c.index(numericCast(-outOfBoundsSubscriptOffset), stepsFrom: index)
      _blackHole(c[index])
    } else {
      expectFailure {
        index = c.index(numericCast(-outOfBoundsSubscriptOffset), stepsFrom: index)
        _blackHole(c[index])
      }
    }
  }

  self.test("\(testNamePrefix).subscript(_: Index)/OutOfBounds/Left/Empty/Get") {
    let c = makeWrappedCollection([])
    var index = c.startIndex
    if resiliencyChecks.subscriptOnOutOfBoundsIndicesBehavior == .trap {
      expectCrashLater()
      index = c.index(numericCast(-outOfBoundsSubscriptOffset), stepsFrom: index)
      _blackHole(c[index])
    } else {
      expectFailure {
        index = c.index(numericCast(-outOfBoundsSubscriptOffset), stepsFrom: index)
        _blackHole(c[index])
      }
    }
  }
}

//===----------------------------------------------------------------------===//
// subscript(_: Range)
//===----------------------------------------------------------------------===//

if resiliencyChecks.subscriptRangeOnOutOfBoundsRangesBehavior != .none {
  self.test("\(testNamePrefix).subscript(_: Range)/OutOfBounds/Left/NonEmpty/Get") {
    let c = makeWrappedCollection([ 1010, 2020, 3030 ].map(OpaqueValue.init))
    var index = c.startIndex
    if resiliencyChecks.subscriptRangeOnOutOfBoundsRangesBehavior == .trap {
      expectCrashLater()
      index = c.index(numericCast(-outOfBoundsSubscriptOffset), stepsFrom: index)
      _blackHole(c[index..<index])
    } else {
      expectFailure {
        index = c.index(numericCast(-outOfBoundsSubscriptOffset), stepsFrom: index)
        _blackHole(c[index..<index])
      }
    }
  }

  self.test("\(testNamePrefix).subscript(_: Range)/OutOfBounds/Left/Empty/Get") {
    let c = makeWrappedCollection([])
    var index = c.startIndex
    if resiliencyChecks.subscriptRangeOnOutOfBoundsRangesBehavior == .trap {
      expectCrashLater()
      index = c.index(numericCast(-outOfBoundsSubscriptOffset), stepsFrom: index)
      _blackHole(c[index..<index])
    } else {
      expectFailure {
        index = c.index(numericCast(-outOfBoundsSubscriptOffset), stepsFrom: index)
        _blackHole(c[index..<index])
      }
    }
  }
}

//===----------------------------------------------------------------------===//
// dropLast()
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).dropLast/semantics") {
  for test in dropLastTests {
    let s = makeWrappedCollection(test.sequence.map(OpaqueValue.init))
    let result = s.dropLast(test.dropElements)
    expectEqualSequence(test.expected, result.map(extractValue).map { $0.value },
      stackTrace: SourceLocStack().with(test.loc))
  }
}

//===----------------------------------------------------------------------===//
// suffix()
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).suffix/semantics") {
  for test in suffixTests {
    let s = makeWrappedCollection(test.sequence.map(OpaqueValue.init))
    let result = s.suffix(test.maxLength)
    expectEqualSequence(test.expected, result.map(extractValue).map { $0.value },
      stackTrace: SourceLocStack().with(test.loc))
  }
}

//===----------------------------------------------------------------------===//

  } // addBidirectionalCollectionTests

  public func addRandomAccessCollectionTests<
    C : RandomAccessCollection,
    CollectionWithEquatableElement : RandomAccessCollection
    where
    C.SubSequence : RandomAccessCollection,
    C.SubSequence.Iterator.Element == C.Iterator.Element,
    C.SubSequence.Index == C.Index,
    C.SubSequence.Indices.Iterator.Element == C.Index,
    C.SubSequence.SubSequence == C.SubSequence,
    C.Indices : RandomAccessCollection,
    C.Indices.Iterator.Element == C.Index,
    C.Indices.Index == C.Index,
    C.Indices.SubSequence == C.Indices,
    CollectionWithEquatableElement.Iterator.Element : Equatable
  >(
    testNamePrefix: String = "",
    makeCollection: ([C.Iterator.Element]) -> C,
    wrapValue: (OpaqueValue<Int>) -> C.Iterator.Element,
    extractValue: (C.Iterator.Element) -> OpaqueValue<Int>,

    makeCollectionOfEquatable: ([CollectionWithEquatableElement.Iterator.Element]) -> CollectionWithEquatableElement,
    wrapValueIntoEquatable: (MinimalEquatableValue) -> CollectionWithEquatableElement.Iterator.Element,
    extractValueFromEquatable: ((CollectionWithEquatableElement.Iterator.Element) -> MinimalEquatableValue),

    checksAdded: Box<Set<String>> = Box([]),
    resiliencyChecks: CollectionMisuseResiliencyChecks = .all,
    outOfBoundsIndexOffset: Int = 1,
    outOfBoundsSubscriptOffset: Int = 1
  ) {
    var testNamePrefix = testNamePrefix

    if checksAdded.value.contains(#function) {
      return
    }
    checksAdded.value.insert(#function)

    addBidirectionalCollectionTests(
      testNamePrefix,
      makeCollection: makeCollection,
      wrapValue: wrapValue,
      extractValue: extractValue,
      makeCollectionOfEquatable: makeCollectionOfEquatable,
      wrapValueIntoEquatable: wrapValueIntoEquatable,
      extractValueFromEquatable: extractValueFromEquatable,
      checksAdded: checksAdded,
      resiliencyChecks: resiliencyChecks,
      outOfBoundsIndexOffset: outOfBoundsIndexOffset,
      outOfBoundsSubscriptOffset: outOfBoundsSubscriptOffset)

    testNamePrefix += String(C.Type)

    func makeWrappedCollection(elements: [OpaqueValue<Int>]) -> C {
      return makeCollection(elements.map(wrapValue))
    }

//===----------------------------------------------------------------------===//
// prefix()
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).prefix/semantics") {
  for test in prefixTests {
    let s = makeWrappedCollection(test.sequence.map(OpaqueValue.init))
    let result = s.prefix(test.maxLength)
    expectEqualSequence(test.expected, result.map(extractValue).map { $0.value },
      stackTrace: SourceLocStack().with(test.loc))
  }
}

//===----------------------------------------------------------------------===//
// suffix()
//===----------------------------------------------------------------------===//

self.test("\(testNamePrefix).suffix/semantics") {
  for test in suffixTests {
    let s = makeWrappedCollection(test.sequence.map(OpaqueValue.init))
    let result = s.suffix(test.maxLength)
    expectEqualSequence(test.expected, result.map(extractValue).map { $0.value },
      stackTrace: SourceLocStack().with(test.loc))
  }
}

//===----------------------------------------------------------------------===//
  } // addRandomAccessCollectionTests
}
