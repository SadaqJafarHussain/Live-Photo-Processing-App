export declare class AutoCaptureError extends Error {
    cause: Error | undefined;
    constructor(message: string, cause?: Error);
    static logError(error: unknown): void;
    static fromCameraError(error: Error): AutoCaptureError;
    static fromError(error: unknown): AutoCaptureError;
}
