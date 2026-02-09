import z from "zod";

export const MarginSchema = z
  .string()
  .regex(/^\d+(\.\d+)?\s*(cm|mm|in|pt|px)$/);

export const MarginsSchema = z.object({
  top: MarginSchema.optional(),
  bottom: MarginSchema.optional(),
  left: MarginSchema.optional(),
  right: MarginSchema.optional(),
});
