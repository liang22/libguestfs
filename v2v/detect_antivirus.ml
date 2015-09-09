(* virt-v2v
 * Copyright (C) 2015 Red Hat Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *)

(* Detect anti-virus (AV) software installed in Windows guests. *)

let rex_virus     = Str.regexp_case_fold "virus" (* generic *)
let rex_kaspersky = Str.regexp_case_fold "kaspersky"
let rex_mcafee    = Str.regexp_case_fold "mcafee"
let rex_norton    = Str.regexp_case_fold "norton"
let rex_sophos    = Str.regexp_case_fold "sophos"

let rec detect_antivirus { Types.i_type = t; i_apps = apps } =
  assert (t = "windows");
  List.exists check_app apps

and check_app { Guestfs.app2_name = name } =
  name      =~ rex_virus     ||
  name      =~ rex_kaspersky ||
  name      =~ rex_mcafee    ||
  name      =~ rex_norton    ||
  name      =~ rex_sophos

and (=~) str rex =
  try ignore (Str.search_forward rex str 0); true with Not_found -> false
