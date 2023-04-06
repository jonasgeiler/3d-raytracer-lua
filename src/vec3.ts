import type { FileHandle } from "node:fs/promises";

export class Vec3 {

	public constructor(
		public x = 0,
		public y = 0,
		public z = 0,
	) {}

	public add(v: Vec3) {
		this.x += v.x;
		this.y += v.y;
		this.z += v.z;
		return this;
	}

	public static add(a: Vec3, b: Vec3) {
		return new Vec3(
			a.x + b.x,
			a.y + b.y,
			a.z + b.z,
		);
	}

	public sub(v: Vec3) {
		this.x -= v.x;
		this.y -= v.y;
		this.z -= v.z;
		return this;
	}

	public static sub(a: Vec3, b: Vec3) {
		return new Vec3(
			a.x - b.x,
			a.y - b.y,
			a.z - b.z,
		);
	}

	public mul(v: Vec3) {
		this.x *= v.x;
		this.y *= v.y;
		this.z *= v.z;
		return this;
	}

	public static mul(a: Vec3, b: Vec3) {
		return new Vec3(
			a.x * b.x,
			a.y * b.y,
			a.z * b.z,
		);
	}

	public scale(t: number) {
		this.x *= t;
		this.y *= t;
		this.z *= t;
		return this;
	}

	public static scale(v: Vec3, t: number) {
		return new Vec3(
			v.x * t,
			v.y * t,
			v.z * t,
		);
	}

	public down(t: number) {
		return this.scale(1 / t);
	}

	public static down(v: Vec3, t: number) {
		return Vec3.scale(v, 1 / t);
	}

	public dot(b: Vec3) {
		return this.x * b.x + this.y * b.y + this.z * b.z;
	}

	public static dot(a: Vec3, b: Vec3) {
		return a.x * b.x + a.y * b.y + a.z * b.z;
	}

	public cross(v: Vec3) {
		const x = this.x;
		const y = this.y;
		const z = this.z;
		const vx = v.x;
		const vy = v.y;
		const vz = v.z;
		this.x = y * vz - z * vy;
		this.y = z * vx - x * vz;
		this.z = x * vy - y * vx;
		return this;
	}

	public static unitVector(v: Vec3) {
		return Vec3.down(v, v.length);
	}

	public get length() {
		return Math.sqrt(this.lengthSquared);
	}

	public get lengthSquared() {
		return this.x * this.x + this.y * this.y + this.z * this.z;
	}

	public toString() {
		return `{${Math.floor(this.x*1000)/1000}, ${Math.floor(this.y*1000)/1000}, ${Math.floor(this.z*1000)/1000}}`;
	}

	public async writeAsColorToFile(fh: FileHandle) {
		await fh.write(`${Math.trunc(255.999 * this.x)} ${Math.trunc(255.999 * this.y)} ${Math.trunc(255.999 * this.z)}\n`);
	}

}

export { Vec3 as Point3 };
export { Vec3 as Color };
