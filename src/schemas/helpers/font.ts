import z from "zod";
import { ColorSchema } from "./color";

export const FontSizeSchema = z.string().regex(/^\d+(px|pt|em|rem|%)$/);
export const FontSchema = z.object({
  family: z.array(z.string()).min(1).optional(),
  size: FontSizeSchema.optional(),
  color: ColorSchema.optional(),
});
