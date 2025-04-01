import type { ObjectValues } from './common';
export declare const SmileInstructionCodeValues: {
    readonly SMILE: "smile";
    readonly SMILE_CANDIDATE_SELECTION: "smile_candidate_selection";
    readonly KEEP_NEUTRAL_EXPRESSION: "keep_neutral_expression";
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
export type SmileInstructionCode = ObjectValues<typeof SmileInstructionCodeValues>;
export type CustomizableSmileInstructionCode = Exclude<SmileInstructionCode, 'mouth_score_too_low' | 'mouth_score_too_high'>;
export declare const SmilePhaseValues: {
    readonly NEUTRAL: "NEUTRAL";
    readonly SMILE: "SMILE";
};
export type SmilePhase = ObjectValues<typeof SmilePhaseValues>;
export declare const SmileStateValues: {
    readonly DONE: "DONE";
    readonly LOADING: "LOADING";
    readonly ERROR: "ERROR";
    readonly WAITING: "WAITING";
    readonly RUNNING: "RUNNING";
};
export type SmileState = ObjectValues<typeof SmileStateValues>;
export type SmileEscalatedInstructionCodes = typeof SmileInstructionCodeValues.SMILE | typeof SmileInstructionCodeValues.KEEP_NEUTRAL_EXPRESSION;
