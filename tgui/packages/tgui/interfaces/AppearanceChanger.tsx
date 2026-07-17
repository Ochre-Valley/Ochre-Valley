import { useBackend } from '../backend';
import { Box, Button, Section, Tabs, ColorBox } from 'tgui-core/components';
import { Window } from '../layouts';
import { useState } from 'react';
type Data = {
  hair_style: string;
  hair_styles: Hair[];
  nat_gradient_style: string
  dye_gradient_style: string
  gradient_styles: Accessory[]
  eye_color: string;
  nat_gradient_color: string;
  dye_gradient_color: string;
  hair_primary: string;
  facial_hair_color: string;
  facial_hair_style: string;
  facial_hair_styles: FacialHair[];
  ear_style: string;
  ear_styles: Accessory[];
  ear_color: string[];
  tail_style: string;
  tail_styles: Accessory[];
  tail_color: string[];
  horn_style: string;
  horn_styles: Accessory[];
  horn_color: string[];
  wing_style: string;
  wing_styles: Accessory[];
  wing_color: string[];
  accessory_style: string;
  accessory_styles: Accessory[];
  detail_style: string;
  detail_styles: Accessory[];
  penis_style: string;
  penis_styles: Accessory[];
  penis_size: number;
  penis_color: string[];
  testicle_style: string;
  testicle_styles: Accessory[];
  testicle_size: number;
  testicle_color: string[];
  vagina_style: string;
  vagina_styles: Accessory[];
  vagina_color: string[];
  breast_style: string;
  breast_styles: Accessory[];
  breast_size: number;
  breast_color: string[];
  has_vagina: number;
  has_wings: number;
  has_horns: number;
  has_tail: number;
  has_ears: number;
  has_breasts: number;
}
type Hair = {
  hairstyle: string;
}
type FacialHair = {
  facialhairstyle: string;
}
type Accessory = {
  name: string;
}
export const AppearanceChanger = () => {
  const { act, config, data } = useBackend<Data>();
  const [tabIndex, setTabIndex] = useState(0);

  return (
    <Window width={700} height={650}>
      <Window.Content>
        <Tabs height="10%">
          <Tabs.Tab selected={tabIndex === 0} onClick={() => setTabIndex(0)}>
            Colors and Gradients
          </Tabs.Tab>
          <Tabs.Tab selected={tabIndex === 1} onClick={() => setTabIndex(1)}>
            Hair
          </Tabs.Tab>
          <Tabs.Tab selected={tabIndex === 2} onClick={() => setTabIndex(2)}>
            Facial Hair
          </Tabs.Tab>
          <Tabs.Tab selected={tabIndex === 3} onClick={() => setTabIndex(3)}>
            Ears
          </Tabs.Tab>
          <Tabs.Tab selected={tabIndex === 4} onClick={() => setTabIndex(4)}>
            Tails
          </Tabs.Tab>
          <Tabs.Tab selected={tabIndex === 5} onClick={() => setTabIndex(5)}>
            Horns
          </Tabs.Tab>
          <Tabs.Tab selected={tabIndex === 6} onClick={() => setTabIndex(6)}>
            Wings
          </Tabs.Tab>
          <Tabs.Tab selected={tabIndex === 7} onClick={() => setTabIndex(7)}>
            Accessories
          </Tabs.Tab>
          <Tabs.Tab selected={tabIndex === 8} onClick={() => setTabIndex(8)}>
            Genitals
          </Tabs.Tab>
        </Tabs>
        <Box height="90%">
          {tabIndex === 0 ? <AppearanceChangerColor /> : null}
          {tabIndex === 1 ? <AppearanceChangerHair /> : null}
          {tabIndex === 2 ? <AppearanceChangerFacialHair />: null}
          {tabIndex === 3 ? <AppearanceChangerEars />: null}
          {tabIndex === 4 ? <AppearanceChangerTails />: null}
          {tabIndex === 5 ? <AppearanceChangerHorns />: null}
          {tabIndex === 6 ? <AppearanceChangerWings />: null}
          {tabIndex === 7 ? (<Section title="Accessories and Details" fill scrollable>
                                <AppearanceChangerAccessory />
                                <AppearanceChangerFaceDetail />
                             </Section>): null}
          {tabIndex === 8 ? <AppearanceChangerBits />: null}
        </Box>
      </Window.Content>
    </Window>
  );
};
const AppearanceChangerColor = () => {
  const { act, data } = useBackend<Data>();
  const{
    eye_color,
    hair_primary,
    facial_hair_color,
    gradient_styles,
    nat_gradient_style,
    dye_gradient_style,
    nat_gradient_color,
    dye_gradient_color,
  } = data;
  return (
    <Section title="Colors and Gradients" fill scrollable>
      <Section title="Colors" >
        <Box>
          <ColorBox color={eye_color} mr={1} />
          <Button content="Change Eye Color" onClick={() => act('eye_color')} />
        </Box>
        <Box>
          <ColorBox color={hair_primary} mr={1} />
          <Button content="Change Hair Color" onClick={() => act('hair_primary')} />
        </Box>
        <Box>
          <ColorBox color={facial_hair_color} mr={1} />
          <Button content="Change Facial Hair Color" onClick={() => act('facial_hair_color')} />
        </Box>
        <Box>
          <ColorBox color={nat_gradient_color} mr={1} />
          <Button content="Change Natural Gradient Color" onClick={() => act('nat_color')} />
        </Box>
        <Box>
          <ColorBox color={dye_gradient_color} mr={1} />
          <Button content="Change Dye Gradient Color" onClick={() => act('dye_color')} />
        </Box>
      </Section>
      <Section title="Gradients">
        <Section title="Natural Hair Gradient">
        {gradient_styles.map((grad) => (
        <Button
          key={grad.name}
          onClick={() => act('natgrad', { grad: grad.name })}
          selected={grad.name === nat_gradient_style}
          content={grad.name}
        />
        ))}
        </Section>
        <Section title="Dye Hair Gradient">
        {gradient_styles.map((grad) => (
        <Button
          key={grad.name}
          onClick={() => act('dyegrad', { grad: grad.name })}
          selected={grad.name === dye_gradient_style}
          content={grad.name}
        />
        ))}
        </Section>
      </Section>
    </Section>
  );
};
const AppearanceChangerHair = () => {
  const { act, data } = useBackend<Data>();

  const { hair_style, hair_styles } = data;

  return (
    <Section title="Hair" fill scrollable>
      {hair_styles.map((hair) => (
        <Button
          key={hair.hairstyle}
          onClick={() => act('hair', { hair: hair.hairstyle })}
          selected={hair.hairstyle === hair_style}
          content={hair.hairstyle}
        />
      ))}
    </Section>
  );
};

const AppearanceChangerFacialHair = () => {
  const { act, data } = useBackend<Data>();

  const { facial_hair_style, facial_hair_styles } = data;

  return (
    <Section title="Facial Hair" fill scrollable>
      {facial_hair_styles.map((hair) => (
        <Button
          key={hair.facialhairstyle}
          onClick={() =>
            act('facial_hair', { facial_hair: hair.facialhairstyle })
          }
          selected={hair.facialhairstyle === facial_hair_style}
          content={hair.facialhairstyle}
        />
      ))}
    </Section>
  );
};

const AppearanceChangerEars = () => {
  const { act, data } = useBackend<Data>();

  const { ear_style, ear_styles, ear_color, has_ears } = data;

  return (
    <Section title="Ears" fill scrollable>
      {has_ears ? (
        <Box>
          {ear_color.map((color, index) => (
              <Box key={index}>
                <ColorBox color={color} mr={1} />
                <Button onClick={() => act('ear_color', { index: index+1 })}> Change Ear Color {index+1}</Button>
              </Box>
          ))}
        </Box>
      ) : "No ears to color!"}
      <Section title="Ear Type">
        <Button
          onClick={() => act('ear', { ear: "none" })}
          selected={ear_style === null}
          content="-- Not Set --"
        />
        {ear_styles.map((ear) => (
          <Button
            key={ear.name}
            onClick={() => act('ear', { ear: ear.name })}
            selected={ear.name === ear_style}
            content={ear.name}
          />
        ))}
      </Section>
    </Section>
  );
};

const AppearanceChangerTails = () => {
  const { act, data } = useBackend<Data>();

  const { tail_style, tail_styles, has_tail, tail_color } = data;

  return (
    <Section title="Tails" fill scrollable>
      {has_tail ? (
        <Box>
          {tail_color.map((color, index) => (
              <Box key={index}>
                <ColorBox color={color} mr={1} />
                <Button onClick={() => act('tail_color', { index: index+1 })}> Change Tail Color {index+1}</Button>
              </Box>
          ))}
        </Box>
      ) : "No tail to color!"}
      <Section title="Tail Types">
        <Button
          onClick={() => act('tail', { tail: "none" })}
          selected={tail_style === null}
          content="-- Not Set --"
        />
        {tail_styles.map((tail) => (
          <Button
            key={tail.name}
            onClick={() => act('tail', { tail: tail.name })}
            selected={tail.name === tail_style}
            content={tail.name}
          />
        ))}
      </Section>
    </Section>
  );
};

const AppearanceChangerHorns = () => {
  const { act, data } = useBackend<Data>();

  const { horn_style, horn_styles, has_horns, horn_color } = data;

  return (
    <Section title="Horns" fill scrollable>
      {has_horns ? (
          <Box>
            <ColorBox color={horn_color[0]} mr={1} />
            <Button content="Change Horn Color" onClick={() => act('horn_color')} />
          </Box>
      ) : "No horns to color!"}
      <Section title="Horn Type">
        <Button
          onClick={() => act('horn', { horn: "none" })}
          selected={horn_style === null}
          content="-- Not Set --"
        />
        {horn_styles.map((horn) => (
          <Button
            key={horn.name}
            onClick={() => act('horn', { horn: horn.name })}
            selected={horn.name === horn_style}
            content={horn.name}
          />
        ))}
      </Section>
    </Section>
  );
};

const AppearanceChangerWings = () => {
  const { act, data } = useBackend<Data>();

  const { wing_style, wing_styles, has_wings, wing_color } = data;

  return (
    <Section title="Wings" fill scrollable>
      {has_wings ? (
          <Box>
            {wing_color.map((color, index) => (
              <Box key={index}>
                <ColorBox color={color} mr={1} />
                <Button onClick={() => act('wing_color', { index: index+1 })}> Change Wing Color {index+1}</Button>
              </Box>
          ))}
          </Box>
      ) : "No wings to color!"}
      <Section title="Wing Types">
        <Button
          onClick={() => act('wing', { wing: "none" })}
          selected={wing_style === null}
          content="-- Not Set --"
        />
        {wing_styles.map((wing) => (
          <Button
            key={wing.name}
            onClick={() => act('wing', { wing: wing.name })}
            selected={wing.name === wing_style}
            content={wing.name}
          />
        ))}
      </Section>
    </Section>
  );
};

const AppearanceChangerAccessory = () => {
  const { act, data } = useBackend<Data>();
  const { accessory_styles, accessory_style } = data;

  return(
    <Section title="Accessories">
      <Button
          onClick={() => act('accessory', { acc: "none" })}
          selected={accessory_style === null}
          content="-- Not Set --"
        />
        {accessory_styles.map((acc) => (
          <Button
            key={acc.name}
            onClick={() => act('accessory', { acc: acc.name })}
            selected={acc.name === accessory_style}
            content={acc.name}
          />
        ))}
    </Section>
  );
};
const AppearanceChangerFaceDetail = () => {
  const { act, data } = useBackend<Data>();
  const { detail_styles, detail_style } = data;

  return(
    <Section title="Face Details">
      <Button
          onClick={() => act('face_detail', { detail: "none" })}
          selected={detail_style === null}
          content="-- Not Set --"
        />
        {detail_styles.map((detail) => (
          <Button
            key={detail.name}
            onClick={() => act('face_detail', { detail: detail.name })}
            selected={detail.name === detail_style}
            content={detail.name}
          />
        ))}
    </Section>
  );
};
const AppearanceChangerBits = () => {
  const [tabIndex, setTabIndex] = useState(0);
  return(
    <Box>
      <Tabs>
        <Tabs.Tab selected={tabIndex === 0} onClick={() => setTabIndex(0)}>
          Penis
        </Tabs.Tab>
        <Tabs.Tab selected={tabIndex === 1} onClick={() => setTabIndex(1)}>
          Balls
        </Tabs.Tab>
        <Tabs.Tab selected={tabIndex === 2} onClick={() => setTabIndex(2)}>
          Vagina
        </Tabs.Tab>
        <Tabs.Tab selected={tabIndex === 3} onClick={() => setTabIndex(3)}>
          Breasts
        </Tabs.Tab>
      </Tabs>
      <Box height="80%">
        {tabIndex === 0 ? <AppearanceChangerBitsPenis /> : null}
        {tabIndex === 1 ? <AppearanceChangerBitsBalls /> : null}
        {tabIndex === 2 ? <AppearanceChangerBitsVagina />: null}
        {tabIndex === 3 ? <AppearanceChangerBitsBreast />: null}
      </Box>
    </Box>
  );
};
const AppearanceChangerBitsPenis = () => {
  const { act, data } = useBackend<Data>();

  const { 
    penis_styles,
    penis_style,
    penis_color,
    penis_size } = data;
  const sizes = ["None", "Small", "Normal", "Large", "Massive", "Enormous"];
    return (
      <Section title="Penis" scrollable>
        {penis_size > 0 ? (
          <Button
            onClick={() => act('penis_size')}
          >
            Size:{sizes[penis_size]}
          </Button>
        ) : "Size: None"}
          {penis_size > 0 ? (
          <Box>
            <ColorBox color={penis_color[0]} mr={1} />
            <Button content="Change Penis Color" onClick={() => act('penis_color')} />
          </Box>
        ) : " and Nothing to color!"}
        <Section title="Penis Type" scrollable>
          <Button
            onClick={() => act('penis', { penis: "none" })}
            selected={penis_style === null}
            content="-- Not Set --"
          />
          {penis_styles.map((penis) => (
            <Button
              key={penis.name}
              onClick={() => act('penis', { penis: penis.name })}
              selected={penis.name === penis_style}
              content={penis.name}
            />
          ))}
        </Section>
      </Section>
  );
};
const AppearanceChangerBitsBalls = () => {
  const { act, data } = useBackend<Data>();

  const { 
    testicle_styles,
    testicle_style,
    testicle_color,
    testicle_size } = data; 
  const sizes = ["None", "Small", "Normal", "Large", "Massive", "Enormous"];
  return(
      <Section title="Testicles" scrollable>
          {testicle_size > 0 ? (
          <Button
            onClick={() => act('testicle_size')}
          >
            Size:{sizes[testicle_size]}
          </Button>
        ) : "Size: None"}
          {testicle_size > 0 ? (
          <Box>
            <ColorBox color={testicle_color[0]} mr={1} />
            <Button content="Change Testicle Color" onClick={() => act('testicle_color')} />
          </Box>
        ) : " and Nothing to color!"}
        <Section title="Testicle Type" scrollable>
          <Button
            onClick={() => act('testicle', { testicle: "none" })}
            selected={testicle_style === null}
            content="-- Not Set --"
          />
          {testicle_styles.map((testicle) => (
            <Button
              key={testicle.name}
              onClick={() => act('testicle', { testicle: testicle.name })}
              selected={testicle.name === testicle_style}
              content={testicle.name}
            />
          ))}
        </Section>
      </Section>
  );
};
const AppearanceChangerBitsVagina = () => {
  const { act, data } = useBackend<Data>();

  const { 
    vagina_styles,
    vagina_style,
    vagina_color,
    has_vagina } = data; 
  return(
      <Section title="Vagina" scrollable>
          {has_vagina ? (
          <Box>
            <ColorBox color={vagina_color[0]} mr={1} />
            <Button content="Change Vagina Color" onClick={() => act('vagina_color')} />
          </Box>
        ) : "Nothing to color!"}
        <Section title="Vagina Type" scrollable>
          <Button
            onClick={() => act('vagina', { vagina: "none" })}
            selected={vagina_style === null}
            content="-- Not Set --"
          />
          {vagina_styles.map((vagina) => (
            <Button
              key={vagina.name}
              onClick={() => act('vagina', { vagina: vagina.name })}
              selected={vagina.name === vagina_style}
              content={vagina.name}
            />
          ))}
        </Section>
      </Section>
  );
};
const AppearanceChangerBitsBreast = () => {
  const { act, data } = useBackend<Data>();

  const { 
    breast_styles,
    breast_style,
    breast_color,
    has_breasts,
    breast_size } = data;
  const sizes = ["Flat", "Very Small", "Small", "Normal",
                "Large", "Enormous", "Towering", "Huge",
                "Gargantuan", "Colossal", "Ungodly", "Gigantic",
                "Titanic", "Obscene", "Overendowed", "Unholy",
                "Baothan"];
    return (
      <Section title="Breasts" scrollable>
        {has_breasts ? (
          <Button
            onClick={() => act('breast_size')}
          >
            Size: {sizes[breast_size]}
          </Button>
        ) : "Size: None"}
        {has_breasts ? (
          <Box>
            <ColorBox color={breast_color[0]} mr={1} />
            <Button content="Change Breast Color" onClick={() => act('breast_color')} />
          </Box>
        ) : " and Nothing to color!"}
        <Section title="Breast Type" scrollable>
          <Button
            onClick={() => act('breast', { breast: "none" })}
            selected={breast_style === null}
            content="-- Not Set --"
          />
          {breast_styles.map((breast) => (
            <Button
              key={breast.name}
              onClick={() => act('breast', { breast: breast.name })}
              selected={breast.name === breast_style}
              content={breast.name}
            />
          ))}
        </Section>
      </Section>
  );
};

