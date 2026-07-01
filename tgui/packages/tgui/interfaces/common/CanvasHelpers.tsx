import {
  PropsWithChildren,
  ReactNode,
  useCallback,
  useEffect,
  useRef,
  useState,
} from 'react';
import { ImageButton } from 'tgui-core/components';

export const getImage = async (url: string): Promise<HTMLImageElement> => {
  return new Promise((resolve, reject) => {
    const image = new Image();
    image.onload = () => {
      resolve(image);
    };
    image.onerror = (event) => {
      reject(event);
    };
    image.src = url;
  });
};

export type CanvasBackedImageProps = {
  width: number;
  height: number;
  render: (
    canvas: OffscreenCanvas,
    ctx: OffscreenCanvasRenderingContext2D,
  ) => Promise<void>;
};

export const CanvasBackedImage = (props: CanvasBackedImageProps) => {
  const { width, height } = props;
  const [bitmap, setBitmap] = useState<string>('');
  const [loadFailed, setLoadFailed] = useState(false);
  const bitmapRef = useRef<string>('');

  useEffect(() => {
    const offscreenCanvas = new OffscreenCanvas(width, height);
    const ctx = offscreenCanvas.getContext('2d');
    if (!ctx) return;

    let active = true;

    setBitmap('');
    bitmapRef.current = '';

    const drawImage = async () => {
      await props.render(offscreenCanvas, ctx);
      if (!active) return;

      const blob = await offscreenCanvas.convertToBlob();
      const url = URL.createObjectURL(blob);

      setBitmap(url);
      bitmapRef.current = url;
    };

    drawImage();
    setLoadFailed(false);

    return () => {
      active = false;
      if (bitmapRef.current) {
        URL.revokeObjectURL(bitmapRef.current);
        bitmapRef.current = '';
      }
    };
  }, [props.render]);

  return (
    <img
      src={bitmap}
      width={width}
      height={height}
      onError={() => setLoadFailed(true)}
      style={{
        visibility: bitmap && !loadFailed ? 'visible' : 'hidden',
      }}
      draggable={false}
    />
  );
};

export type ColorizedImageProps = {
  iconRef: string;
  iconState: string;
  color?: string | null;
  colorBlendingMode?: GlobalCompositeOperation;
  dir?: string;
  preRender?: (ctx: OffscreenCanvasRenderingContext2D) => Promise<void>;
  postRender?: (ctx: OffscreenCanvasRenderingContext2D) => Promise<void>;
  width?: number;
  height?: number;
};

export const ColorizedImage = (props: ColorizedImageProps) => {
  const {
    iconRef,
    iconState,
    color,
    colorBlendingMode,
    dir,
    preRender,
    postRender,
    width,
    height,
  } = props;

  let realWidth = width || 64;
  let realHeight = height || 64;
  let realColorBlendingMode = colorBlendingMode || 'multiply';

  const render = useCallback(
    async (canvas: OffscreenCanvas, ctx: OffscreenCanvasRenderingContext2D) => {
      // Pixel art please
      ctx.imageSmoothingEnabled = false;

      if (preRender) await preRender(ctx);

      const finalDir = dir || '2';

      // Load the image from the server
      let image;
      try {
        image = await getImage(
          `${iconRef}?state=${iconState}&dir=${finalDir}&frame=1`,
        );
      } catch (e) {
        ctx.fillStyle = '#ff0000';
        ctx.fillRect(0, 0, 64, 64);
        return;
      }

      // Draw the image to the canvas
      ctx.drawImage(image, 0, 0, realWidth, realHeight);

      // Draw a square over the image with the color
      ctx.globalCompositeOperation = realColorBlendingMode;
      ctx.fillStyle = color || '#ffffff';
      ctx.fillRect(0, 0, realWidth, realHeight);

      // Use the image as a mask
      ctx.globalCompositeOperation = 'destination-in';
      ctx.drawImage(image, 0, 0, realWidth, realHeight);

      if (postRender) await postRender(ctx);
    },
    [
      iconRef,
      iconState,
      color,
      preRender,
      postRender,
      dir,
      realWidth,
      realHeight,
      realColorBlendingMode,
    ],
  );

  return (
    <CanvasBackedImage width={realWidth} height={realHeight} render={render} />
  );
};

export type CustomImageButtonProps = PropsWithChildren<{
  image: ReactNode;
  fluid?: boolean;
  tooltip?: string;
  selected?: boolean;
  onClick: () => void;
  buttons?: ReactNode;
}>;

export const CustomImageButton = (props: CustomImageButtonProps) => {
  return (
    <ImageButton
      dmIcon="not_a_real_icon.dmi"
      dmIconState="equally_fake_icon_state"
      dmFallback={props.image}
      fluid={props.fluid}
      onClick={props.onClick}
      tooltip={props.tooltip}
      selected={props.selected}
      buttons={props.buttons}
      verticalAlign="top"
    >
      {props.children}
    </ImageButton>
  );
};

export type ColorizedImageButtonProps = PropsWithChildren<{
  iconRef: string;
  iconState: string;
  color?: string | null;
  colorBlendingMode?: GlobalCompositeOperation;
  dir?: string;
  onClick: () => void;
  preRender?: (ctx: OffscreenCanvasRenderingContext2D) => Promise<void>;
  postRender?: (ctx: OffscreenCanvasRenderingContext2D) => Promise<void>;
  selected?: boolean;
  tooltip?: string;
  buttons?: ReactNode;
  width?: number;
  height?: number;
}>;

export const ColorizedImageButton = (props: ColorizedImageButtonProps) => {
  const {
    iconRef,
    iconState,
    color,
    colorBlendingMode,
    dir,
    onClick,
    selected,
    preRender,
    postRender,
    width,
    height,
  } = props;

  return (
    <CustomImageButton
      image={
        <ColorizedImage
          iconRef={iconRef}
          iconState={iconState}
          color={color}
          colorBlendingMode={colorBlendingMode}
          dir={dir}
          preRender={preRender}
          postRender={postRender}
          width={width}
          height={height}
        />
      }
      onClick={onClick}
      selected={selected}
      tooltip={props.tooltip}
      buttons={props.buttons}
    >
      {props.children}
    </CustomImageButton>
  );
};
