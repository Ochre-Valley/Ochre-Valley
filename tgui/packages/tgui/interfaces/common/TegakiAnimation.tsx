import { type ReactNode, useEffect, useState } from 'react';
import {
  createBundle,
  type TegakiBundle,
  TegakiRenderer,
  type TegakiRendererProps,
} from 'tegaki/react';
import { Box, Stack } from 'tgui-core/components';

const getFont = async () => {
  try {
    const glyphData = await fetch('parisienne_data.json').then((r) => r.json());

    return createBundle({
      family: 'Parisienne',
      fontUrl: 'parisienne.ttf',
      glyphData,
      unitsPerEm: 2048,
      ascender: 1875,
      descender: -915,
    });
  } catch {
    return null;
  }
};

export type TegakiAnimationProps = { height: number } & Pick<
  TegakiRendererProps,
  'time' | 'children' | 'style'
>;

// OV EDITS - FIXING WELCOME MESSAGE
export const TegakiAnimation = (props: TegakiAnimationProps) => {
  const { height } = props;
  const [font, setFont] = useState<undefined | null | TegakiBundle>(undefined);
  const [prog, setProg] = useState(0);
  const [playing, setPlaying] = useState(false);

  useEffect(() => {
    (async () => {
      setFont(await getFont());
      setPlaying(true);
    })();
  }, []);

  useEffect(() => {
    if (!playing) return;
    let id: any | null = setInterval(() => {
      setProg((x) => {
        if (x > 100) {
          clearInterval(id);
          id = null;
          return 100;
        }
        return x + 0.15;
      });
    });
    return () => {
      if (!id) return;
      clearInterval(id);
    };
  }, [playing]);

  let inner: ReactNode;
  if (font === undefined) {
    inner = null;
  } else if (font === null) {
    inner = (
      <Box
        fontFamily="MedievalSharp"
        style={{
          animation: 'fadeIn 5s',
          ...props.style,
        }}
      >
        {props.children}
      </Box>
    );
  } else {
    inner = <TegakiRenderer font={font} time={`${prog}%`} {...props} />;
  }

  return (
    <Stack height={height} align="center" justify="center">
      <Stack.Item>{inner}</Stack.Item>
    </Stack>
  );
};
// OV EDITS END - FIXING WELCOME MESSAGE
