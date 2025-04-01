import type { ObjectValues } from './common';
export declare const MagnifEyeInstructionCodeValues: {
    readonly FIT_YOUR_EYE: "fit_your_eye";
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
export type MagnifEyeInstructionCode = ObjectValues<typeof MagnifEyeInstructionCodeValues>;
export declare enum MagnifEyePhase {
    CLOSEUP = "CLOSEUP",
    DISTANT = "DISTANT",
    MIDDLE = "MIDDLE"
}
export declare const MagnifEyeStateValues: {
    readonly DONE: "DONE";
    readonly LOADING: "LOADING";
    readonly ERROR: "ERROR";
    readonly WAITING: "WAITING";
    readonly RUNNING: "RUNNING";
};
export type MagnifEyeState = ObjectValues<typeof MagnifEyeStateValues>;
