/*  $Id$

    Part of XPCE

    Author:  Jan Wielemaker and Anjo Anjewierden
    E-mail:  jan@swi.psy.uva.nl
    WWW:     http://www.swi.psy.uva.nl/projects/xpce/
    Copying: GPL-2.  See the file COPYING or http://www.gnu.org

    Copyright (C) 1990-2001 SWI, University of Amsterdam. All rights reserved.
*/

#ifndef _PCE_UNX_INCLUDED
#define _PCE_UNX_INCLUDED

#include <h/graphics.h>
#include <unx/proto.h>

#ifdef HAVE_UXNT_H
#include <uxnt.h>
#endif


		 /*******************************
		 *	   AUTOCONF STUFF	*
		 *******************************/

#ifndef __USE_W32_SOCKETS		/* Cygwin using winsock */
#ifdef TIME_WITH_SYS_TIME
#include <sys/time.h>
#include <time.h>
#else
#ifdef HAVE_SYS_TIME_H
#include <sys/time.h>
#else
#include <time.h>
#endif
#endif
#endif /*__USE_W32_SOCKETS*/

		 /*******************************
		 *	 DOS/UNIX PROBLEMS	*
		 *******************************/

#if defined(O_DOSFILENAMES) && O_DOSFILENAMES
#define IsDirSep(c) ((c) == '/' || (c) == '\\')
#else
#define IsDirSep(c) ((c) == '/')
#endif

		 /*******************************
		 *     AND THE NEAT STUFF!	*
		 *******************************/

#define ABSTRACT_STREAM \
  Code		input_message;		/* Message forwarded on input */ \
  Any		record_separator;	/* Separate input records */ \
  int		wrfd;			/* FD to write to process */ \
  int		rdfd;			/* FD to read from process */ \
  FILE *	rdstream;		/* Stream to read from process */ \
  WsRef		ws_ref;			/* Window System Handle */ \
  unsigned char * input_buffer;		/* Input buffer */ \
  int		input_allocated;	/* Allocated size of buffer */ \
  int		input_p;		/* Pointer into input buffer */


NewClass(fileobj)
  ABSTRACT_SOURCE_SINK
  Name		name;			/* name of the file */
  Name		path;			/* full path-name of the file */
  Name		kind;			/* {text,binary} */
  Name		status;			/* current open mode */
  Name		filter;			/* I/O filter used */
  FILE		*fd;			/* file descriptor */
End;


NewClass(rc)
  ABSTRACT_SOURCE_SINK
  Name		name;			/* name of the resource */
  Name		rc_class;		/* class of the resource */
  Any		context;		/* Module info */
End;


NewClass(directory)
  Name		name;			/* name of directory */
  Name		path;			/* full path name */
  unsigned long modified;		/* time stamp */
End;


NewClass(stream)
  ABSTRACT_STREAM
End;


NewClass(process)
  ABSTRACT_STREAM
  CharArray	name;			/* name of command ran */
  Vector	arguments;		/* vector of arguments */
  Name		status;			/* status of process */
  Any		code;			/* Signal/exit status */
  Bool		use_tty;		/* use a tty? */
  Name		tty;			/* Pseudo tty used */
  Code		terminate_message;	/* message forwarded o terminate */
  Int		pid;			/* Process id */
  Directory	directory;		/* Initial working dir */
  Sheet		environment;		/* Child environment  */
End;


NewClass(socketobj)
  ABSTRACT_STREAM
  Any		address;		/* Address for the socket  */
  Name		domain;			/* {unix,inet}  */
  Name		status;			/* status of socket */
  Code		accept_message;		/* message forwarded on accept */
  Chain		clients;		/* Chain of accepted sockets */
  Socket	master;			/* Master socket (listen)  */
  FileObj	authority;		/* Authority-file */
End;

#endif /* _PCE_UNX_INCLUDED */
