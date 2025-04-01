import type { InstructionChangeEvent } from './common';
import type { DetectedFace, FaceInstructionCode } from '../face';
export declare enum FaceCustomEvent {
    CAMERA_PROPS_CHANGED = "face-auto-capture:camera-props-changed",
    CONTROL = "face-auto-capture:control",
    DETECTED_FACE_CHANGED = "face-auto-capture:detected-face-changed",
    FACE_DETECTION = "face-auto-capture:face-detection",
    INSTRUCTION_CHANGED = "face-auto-capture:instruction-changed",
    STATE_CHANGED = "face-auto-capture:state-changed",
    VIDEO_ELEMENT_SIZE = "face-auto-capture:video-element-size"
}
export type DetectedFaceChangeEvent = {
    detail?: {
        detectedObject: DetectedFace;
    };
} & Event;
export type FaceInstructionChangeEvent = InstructionChangeEvent<FaceInstructionCode>;
export type DispatchFaceDetectionEvent = {
    detection: DetectedFace;
    eventName: FaceCustomEvent.FACE_DETECTION;
};
