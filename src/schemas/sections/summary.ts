import z from "zod";

export const SummarySchema = z.object({
  sentences: z.array(z.string().nonempty()).min(1).nonoptional(),
});
