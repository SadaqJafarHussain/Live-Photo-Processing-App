import type { DeepPartial, DeepRequired } from '../../../ui-common/src/types';
import type { CSSProperties } from 'styled-components';
export type AutoCaptureTheme = {
    colors: {
        instructionColor: string;
        instructionColorSuccess: string;
        instructionTextColor: string;
        placeholderColor: string;
        placeholderColorSuccess: string;
    };
    font: {
        family: CSSProperties['fontFamily'];
        minimumSize: number;
        style: CSSProperties['fontStyle'];
        weight: CSSProperties['fontWeight'];
    };
};
export type AppStateInstruction = {
    text?: string;
    visible?: boolean;
};
export type AppStateInstructions = {
    loading?: AppStateInstruction;
    waiting?: AppStateInstruction;
};
export type UiAppStateInstructions = {
    [key: string]: DeepRequired<AppStateInstruction>;
};
export type EscalatedInstructions<I extends string> = {
    escalatedInstructions?: Partial<Record<I, string>>;
};
export type UiProps<I, SI = AppStateInstructions> = {
    appStateInstructions?: SI;
    backdropColor?: string;
    instructions?: Partial<I>;
    showCameraButtons?: boolean;
    styleTarget?: HTMLElement;
    theme?: DeepPartial<AutoCaptureTheme>;
};
export type BaseComponentsUiProps<P> = {
    placeholder?: P;
    showDetectionLayer?: boolean;
};
export type CameraButtonIconProps = {
    size: number;
};
export type HTMLElementWithProps<P> = HTMLElement & {
    props: P;
};
export type CustomizationContextProps<P extends UiProps<unknown, unknown>> = Omit<P, 'appStateInstructions' | 'styleTarget' | 'theme'> & {
    appStateInstructions: UiAppStateInstructions;
    theme: AutoCaptureTheme;
};
