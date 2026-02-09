import z from "zod";

export const ProjectSchema = z.object({
  name: z.string().nonempty().nonoptional(),
  stack: z.array(z.string().nonempty()).optional(),
  url: z.url().optional(),
  activities: z.array(z.string().nonempty()).optional(),
});

export const ProjectsSchema = z.array(ProjectSchema);
