import type { ImageParameters, ObjectValues, Point } from './common';
export declare const FaceInstructionCodeValues: {
    readonly CANDIDATE_SELECTION: "candidate_selection";
    readonly FACE_TOO_CLOSE: "face_too_close";
    readonly FACE_TOO_FAR: "face_too_far";
    readonly FACE_CENTERING: "face_centering";
    readonly FACE_NOT_PRESENT: "face_not_present";
    readonly SHARPNESS_TOO_LOW: "sharpness_too_low";
    readonly BRIGHTNESS_TOO_LOW: "brightness_too_low";
    readonly BRIGHTNESS_TOO_HIGH: "brightness_too_high";
    readonly DEVICE_PITCHED: "device_pitched";
    readonly LEFT_EYE_NOT_PRESENT: "left_eye_not_present";
    readonly RIGHT_EYE_NOT_PRESENT: "right_eye_not_present";
    readonly MOUTH_NOT_PRESENT: "mouth_not_present";
    readonly MOUTH_SCORE_TOO_HIGH: "mouth_score_too_high";
    readonly MOUTH_SCORE_TOO_LOW: "mouth_score_too_low";
};
export declare const FaceCheckToInstructionCodeMap: {
    isPresent: "face_not_present";
    isNotPitched: "device_pitched";
    isNotSmall: "face_too_far";
    isNotLarge: "face_too_close";
    isNotOutOfBounds: "face_centering";
    isNotDim: "brightness_too_low";
    isNotBright: "brightness_too_high";
    isSharp: "sharpness_too_low";
    isLeftEyePresent: "left_eye_not_present";
    isRightEyePresent: "right_eye_not_present";
    isMouthPresent: "mouth_not_present";
    isMouthScoreNotTooHigh: "mouth_score_too_high";
    isMouthScoreNotTooLow: "mouth_score_too_low";
};
export type FaceInstructionCode = ObjectValues<typeof FaceInstructionCodeValues>;
export type DetectedFacePart = {
    center: Point;
    confidence: number;
    size: number;
    status: number;
};
export type DetectedFace = FaceImageParameters & DetectedFaceCorners & {
    confidence: number;
    faceSize: number;
    leftEye: DetectedFacePart;
    mouth: DetectedFacePart;
    rightEye: DetectedFacePart;
};
export type DetectedFaceCorners = {
    bottomRight: Point;
    faceCenter: Point;
    topLeft: Point;
};
export type FaceImageParameters = ImageParameters;
