import type { DetectedCorners, ImageParameters, ObjectValues } from './common';
export declare const DocumentInstructionCodeValues: {
    readonly CANDIDATE_SELECTION: "candidate_selection";
    readonly DOCUMENT_CENTERING: "document_centering";
    readonly DOCUMENT_NOT_PRESENT: "document_not_present";
    readonly DOCUMENT_TOO_FAR: "document_too_far";
    readonly SHARPNESS_TOO_LOW: "sharpness_too_low";
    readonly BRIGHTNESS_TOO_LOW: "brightness_too_low";
    readonly BRIGHTNESS_TOO_HIGH: "brightness_too_high";
    readonly HOTSPOTS_PRESENT: "hotspots_present";
};
export declare const DocumentCheckToInstructionCodeMap: {
    isPresent: "document_not_present";
    isNotSmall: "document_too_far";
    isNotOutOfBounds: "document_centering";
    isSharp: "sharpness_too_low";
    isNotDim: "brightness_too_low";
    isNotBright: "brightness_too_high";
    noHotspots: "hotspots_present";
};
export type DocumentInstructionCode = ObjectValues<typeof DocumentInstructionCodeValues>;
export type DetectedDocumentCorners = DetectedCorners;
export type DocumentImageParameters = ImageParameters & {
    hotspots: number;
};
export type DetectedDocument = DocumentImageParameters & DetectedDocumentCorners & {
    confidence: number;
    smallestEdge: number;
};
export type DocumentEscalatedInstructionCodes = typeof DocumentInstructionCodeValues.DOCUMENT_TOO_FAR | typeof DocumentInstructionCodeValues.BRIGHTNESS_TOO_HIGH | typeof DocumentInstructionCodeValues.BRIGHTNESS_TOO_LOW | typeof DocumentInstructionCodeValues.SHARPNESS_TOO_LOW;
