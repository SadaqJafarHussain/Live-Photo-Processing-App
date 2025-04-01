import type { InstructionChangeEvent } from './common';
import type { DetectedPalm, PalmInstructionCode } from '../palm';
export declare enum PalmCustomEvent {
    CAMERA_PROPS_CHANGED = "palm-capture:camera-props-changed",
    CONTROL = "palm-capture:control",
    DETECTED_PALM_CHANGED = "palm-capture:detected-palm-changed",
    INSTRUCTION_CHANGED = "palm-capture:instruction-changed",
    STATE_CHANGED = "palm-capture:state-changed",
    VIDEO_ELEMENT_SIZE = "palm-capture:video-element-size"
}
export type DetectedPalmChangeEvent = {
    detail?: {
        detectedObject: DetectedPalm;
    };
} & Event;
export type PalmInstructionChangeEvent = InstructionChangeEvent<PalmInstructionCode>;
