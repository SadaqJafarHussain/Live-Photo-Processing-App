import type { AutoCaptureError } from '../../error';
export type AnimationEndEvent = {
    detail?: {
        animationEnd: boolean;
    };
} & Event;
export type StatusChangeEvent<Phase, State> = {
    detail?: {
        error?: AutoCaptureError;
        phase?: Phase;
        state?: State;
    };
} & Event;
