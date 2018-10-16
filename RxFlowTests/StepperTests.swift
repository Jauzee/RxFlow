//
//  StepperTests.swift
//  RxFlowTests
//
//  Created by Thibault Wittemberg on 2018-10-15.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import XCTest
import RxFlow
import RxBlocking

enum StepperTestsStep: Step {
    case stepOne
}

final class StepperClass: Stepper {
    func emitStepOne () {
        self.step.accept(StepperTestsStep.stepOne)
    }
}

class StepperTests: XCTestCase {

    func testStepperEmitStep() {

        let stepExceptation = expectation(description: "Step expectation")

        // Given: a stepper
        let stepperClass = StepperClass()

        // When: emitting a new step
        stepperClass.emitStepOne()

        // Then: the right step is emitted
        _ = stepperClass
            .steps
            .takeUntil(self.rx.deallocating)
            .subscribe(onNext: { step in
                print (step)
                if case StepperTestsStep.stepOne = step {
                    stepExceptation.fulfill()
                }
            })

        waitForExpectations(timeout: 1)
    }

}
