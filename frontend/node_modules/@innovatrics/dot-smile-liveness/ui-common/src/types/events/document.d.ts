import type { InstructionChangeEvent, InstructionEscalatedEvent } from './common';
import type { DetectedDocument, DocumentInstructionCode } from '../document';
export declare enum DocumentCustomEvent {
    CAMERA_PROPS_CHANGED = "document-auto-capture:camera-props-changed",
    CONTROL = "document-auto-capture:control",
    DETECTED_DOCUMENT_CHANGED = "document-auto-capture:detected-document-changed",
    DOCUMENT_DETECTION = "document-auto-capture:document-detection",
    INSTRUCTION_CHANGED = "document-auto-capture:instruction-changed",
    INSTRUCTION_ESCALATED = "document-auto-capture:instruction-escalated",
    STATE_CHANGED = "document-auto-capture:state-changed",
    VIDEO_ELEMENT_SIZE = "document-auto-capture:video-element-size"
}
export type DetectedDocumentChangeEvent = {
    detail?: {
        detectedObject: DetectedDocument;
    };
} & Event;
export type DocumentInstructionChangeEvent = InstructionChangeEvent<DocumentInstructionCode>;
export type DispatchDocumentDetectionEvent = {
    detection: DetectedDocument;
    eventName: DocumentCustomEvent.DOCUMENT_DETECTION;
};
export type DocumentInstructionEscalatedEvent = InstructionEscalatedEvent<DocumentInstructionCode>;
