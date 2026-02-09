import z from "zod";

export const HEX_COLOR_REGEX =
  /^#([A-F0-9]{6}|[A-F0-9]{3}|[a-f0-9]{6}|[a-f0-9]{3})$/;
export const RGB_COLOR_REGEX =
  /^rgb\(\s*(?:[01]?\d\d?|2[0-4]\d|25[0-5])\s*,\s*(?:[01]?\d\d?|2[0-4]\d|25[0-5])\s*,\s*(?:[01]?\d\d?|2[0-4]\d|25[0-5])\s*\)$/;
export const RGBA_COLOR_REGEX =
  /^rgba\(\s*(?:[01]?\d\d?|2[0-4]\d|25[0-5])\s*,\s*(?:[01]?\d\d?|2[0-4]\d|25[0-5])\s*,\s*(?:[01]?\d\d?|2[0-4]\d|25[0-5])\s*,\s*(0|0?\.\d+|1(\.0)?)\s*\)$/;
export const HSL_COLOR_REGEX =
  /^hsl\(\s*(?:[0-9]|[1-2][0-9]{1,2}|3[0-5][0-9]|360)\s*,\s*(?:[0-9]{1,2}|100)%\s*,\s*(?:[0-9]{1,2}|100)%\s*\)$/;
export const HSLA_COLOR_REGEX =
  /^hsla\(\s*(?:[0-9]|[1-2][0-9]{1,2}|3[0-5][0-9]|360)\s*,\s*(?:[0-9]{1,2}|100)%\s*,\s*(?:[0-9]{1,2}|100)%\s*,\s*(0|0?\.\d+|1(\.0)?)\s*\)$/;
export const CMYK_COLOR_REGEX =
  /^cmyk\(\s*(?:\d{1,2}|100)%?\s*,\s*(?:\d{1,2}|100)%?\s*,\s*(?:\d{1,2}|100)%?\s*,\s*(?:\d{1,2}|100)%?\s*\)$/i;

export function isColorString(value: string): boolean {
  return (
    HEX_COLOR_REGEX.test(value) ||
    RGB_COLOR_REGEX.test(value) ||
    RGBA_COLOR_REGEX.test(value) ||
    HSL_COLOR_REGEX.test(value) ||
    HSLA_COLOR_REGEX.test(value) ||
    CMYK_COLOR_REGEX.test(value)
  );
}

export const ColorSchema = z.string().refine((val) => isColorString(val), {
  message: "Invalid color format",
});
