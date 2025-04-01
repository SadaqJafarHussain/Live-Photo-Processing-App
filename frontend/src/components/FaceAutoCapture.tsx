import type {
  FaceCallback,
  FaceComponentData,
} from "@innovatrics/dot-face-auto-capture";
import {
  dispatchControlEvent,
  FaceCustomEvent,
  ControlEventInstruction,
} from "@innovatrics/dot-face-auto-capture/events";
import { useState, useEffect } from "react";
import styles from "../styles/index.module.css";
import buttonStyles from "../styles/button.module.css";
import FaceCamera from "./FaceCamera";
import FaceUi from "./FaceUi";

interface Props {
  onPhotoTaken: FaceCallback;
  onError: (error: Error) => void;
  onNextClick: () => void;
  isProcessing: boolean;
  photoUrl?: string; // Add photoUrl prop
}

function FaceAutoCapture({
  onPhotoTaken,
  onError,
  onNextClick,
  isProcessing,
  photoUrl
}: Props) {
  const [guideText, setGuideText] = useState<string>("");

  const handlePhotoTaken: FaceCallback = async (imageData, content) => {
    onPhotoTaken(imageData, content);
  };

  const handleContinueDetection = () => {
    dispatchControlEvent(
      FaceCustomEvent.CONTROL,
      ControlEventInstruction.CONTINUE_DETECTION
    );
  };

  return (
    <div style={{ fontFamily: "Cairo, sans-serif" }}>
      <div className={styles.container}>
        <FaceCamera
          cameraFacing="user"
          onPhotoTaken={handlePhotoTaken}
          onError={onError}
        />
        <FaceUi
          showCameraButtons
          instructions={
            {
              sharpness_too_low:"واجه الضوء",
              face_not_present:"ضع وجهك في المنتصف",
              face_too_close:"ابتعد قليلا",
              face_too_far:"اقترب قليلا",
              brightness_too_high:"خفف الاضاءه قليلا",
              left_eye_not_present:"ضع وجهك في المنتصف",
              right_eye_not_present:"ضع وجهك في المنتصف",
              device_pitched:"ضع هاتفك في مستوى وجهك",
              mouth_not_present:"ضع وجهك في المنتصف",
              brightness_too_low:"الاضاءه ضعيفه جدا",
              face_centering:"ضع وجهك في المنتصف",
              candidate_selection:"ابقى ثابت  "
              
            }
          }
    
        />
      </div>

      <div>
        <button
          className={buttonStyles.primary}
          onClick={handleContinueDetection}
          disabled={isProcessing || !photoUrl} // Disable button if isProcessing is true or no photoUrl
        >
          اعادة الالتقاط
        </button>
        <button
  className={buttonStyles.primary}
  onClick={onNextClick}
  disabled={isProcessing || !photoUrl} // Disable when processing
>
  {isProcessing ? (
    <span className={buttonStyles.spinner}></span> // Show spinner
  ) : (
    "التالي"
  )}
</button>
      </div>

      {guideText && (
        <div
          style={{
            position: "absolute",
            top: "50%",
            left: "50%",
            transform: "translate(-50%, -50%)",
            background: "rgba(0, 0, 0, 0.5)",
            padding: "10px 20px",
            color: "white",
            fontSize: "18px",
            borderRadius: "10px",
          }}
          aria-live="polite" // To announce guide text for accessibility
        >
          {guideText}
        </div>
      )}
    </div>
  );
}

export default FaceAutoCapture;
