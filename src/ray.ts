import { Point3, Vec3 } from "./vec3.js";

export class Ray {

	public constructor(
		public origin: Point3,
		public direction: Vec3,
	) {}

	public at(t: number) {
		return Vec3.add(this.origin, Vec3.scale(this.direction, t));
	}

}
