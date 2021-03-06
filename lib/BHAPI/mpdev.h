/*! \file mpdev.h
	\author BIOPAC Systems, Inc.
	\version 1.0
    \brief  BIOPAC Hardware API allows third-party software programs to communicate with BIOPAC MP Devices

	The Hardware API is compatible with MP150 communicating via Ethernet using UDP.

	The Hardware API allows developers to create software programs that communicate directly to the MP Device.

	Uses:
	- Acquire data on all 16 Analog Channels
	- Acquire data at different sample rates
	- Output data to both Analog outputs (Digital to Analog)
	- Read and Write Values to all 16 Digital I/O
	- Trigger acquisition via the External Trigger or any of the Analog Channels
*/

#ifndef _MPDEV_H_
#define _MPDEV_H_

#include <windows.h>

//! Enumerated values for MP Devices.
/*! Represents supported MP Devices.*/
typedef enum
{
	MP100 = 100, /**< represents the MP100 unit */
	MP150	/**< represents the MP150 unit */
} MPTYPE;

//! Enumerated values for the MP Device communication types.
/*! Represents supported MP communication types.*/
typedef enum
{
	MPUSB = 10, /**< represents communication via USB */
	MPUDP	/**< represents communication via Ethernet using UDP */
} MPCOMTYPE;

//! Enumerated values for MP Device triggering options
/*! Represents supported MP triggering options. */
typedef enum
{
	MPTRIGOFF = 1, /**< represents triggering off */
	MPTRIGEXT,	/**< represents external triggering */
	MPTRIGACH	/**< represents Analog Channel triggering */
} TRIGGEROPT;

//! Enumerated values for the MP Device Digital I/O options
/*! Represents supported MP digital line reading or writing options. */
typedef enum
{
	SET_LOW_BITS = 1, /**< set only Digital I/O lines 0 through 7 */
	SET_HIGH_BITS, /**< set only Digital I/O lines 8 through 15 */
	READ_LOW_BITS, /**< read only Digital I/O lines 0 through 7 */
	READ_HIGH_BITS /**< read only Digital I/O lines 8 through 16 */
} DIGITALOPT;

//! Enumerated return code values.
/*! Return codes that are generated by Hardware API functions. */
typedef enum
{
	MPSUCCESS = 1, /**< = successful execution */
	MPDRVERR,	/**< = error communicating with BIOPAC USB1W*/
	MPDLLBUSY,	/**< = a process is using the API, only one process may use the dll */
	MPINVPARA,	/**< = invalid parameter(s)*/
	MPNOTCON,	/**< = MP Device is not connected */
	MPREADY,	/**< = MP Device is ready */
	MPWPRETRIG, /**< = MP Device is waiting for pre-trigger (pre-triggering is not implemented) */
	MPWTRIG,	/**< = MP Device is waiting for trigger */
	MPBUSY,		/**< = MP Device is busy */
	MPNOACTCH,	/**< = there are no active channels, at least one channel must be active */
	MPCOMERR,	/**< = general communication error */
	MPINVTYPE,	/**< = the function is incompatible with the selected MP Device and/or communication method */
	MPNOTINNET,	/**< = MP150 is not in the network */
	MPSMPLDLERR,/**< = MP unit overwrote samples that has not been downloaded */
	MPMEMALLOCERR, /**< = error allocating memory */
	MPSOCKERR	/**< = internal socket error */
} MPRETURNCODE;

#define MPDLL_EXPORT __declspec(dllexport)

#ifdef __cplusplus
extern "C"
{
#endif

/** Connect to the specified MP Device.
 *
 *	This function MUST be called first when using the Hardware API.
 *
 *	\param type the type of device you want to connect with, must use <em>MPTYPE</em> enumerated values.
 *	\param method the type of communication method, must use <em>MPCOMTYPE</em> enumerated values.
 *	\param MP150SN can be set to any string if not using MP150 via Ethernet using UDP, otherwise it's the serial number of the MP150.
 *	\return <em>MPRETURNCODE</em>
 */
MPDLL_EXPORT MPRETURNCODE _stdcall connectMPDev(MPTYPE type, MPCOMTYPE method, char * MP150SN);

/** Disconnect from the MP Device
 *
 *	\return <em>MPRETURNCODE</em>
 */
MPDLL_EXPORT MPRETURNCODE _stdcall disconnectMPDev();

/** Get the status of the MP Device
 *
 *	\return <em>MPRETURNCODE</em>
 */
MPDLL_EXPORT MPRETURNCODE _stdcall getStatusMPDev();

/** Set the analog channels to acquire
 *
 *	At least one channel must be set <em>true</em> for acquisition.
 *
 *	\param aCH an array of 16 booleans, enables/disables acquisition on the corresponding analog channel
 *	\note aCH[<em>i</em>] = <em>true</em> implies that the MP Device will acquire from Channel <em>i</em>+1.
 *		  \n
 *		  aCH[<em>i</em>] = <em>false</em> implies that the MP Device will not acquire from Channel <em>i</em>+1.
 *		  \n
 *		  Where 0 &lt;= <em>i</em> &lt; 16
 *	\return <em>MPRETURNCODE</em>
 */
MPDLL_EXPORT MPRETURNCODE _stdcall setAcqChannels(BOOL * aCH);

/** Set MP Device sample rate
 *
 *	\note
 *	\htmlinclude samplerates.txt
 *
 *	\param rate MP device sampling rate in msec/sample
 *
 *	\warning
			  - For the MP150, only use the sample rates listed above.
			  - Unexpected results may occur if the incoming data are not transferred and processed as quickly and efficiently as possible.
 *	\return <em>MPRETURNCODE</em>
 */
MPDLL_EXPORT MPRETURNCODE _stdcall setSampleRate(double rate);

/** Set the voltage of a given analog output
 *
 *	\warning
 *		For safety, always set analog output channels back to zero volts before your program exits or physically power cycle the MP Device.  If you do not set the voltage level back to zero the analog output channels may continue to output a non-zero voltage.
 *
 *	\param value voltage to set the specific output channel, -10 &lt;= <em>value</em> &lt;= 10
 *	\param outchan specify the output channel number, <em>outchan</em> = 1 or <em>outchan</em> = 0
 *	\return <em>MPRETURNCODE</em>
 */
MPDLL_EXPORT MPRETURNCODE _stdcall setAnalogOut(double value, int outchan);

/** Start the Acquisition
 *
 *	At least one channel must be set active for acquisition. This method will fail if invalid or unsupported acquisition parameters are given. If a trigger is set, this function will not return until the trigger is received by the MP Device.
 *
 *	\return <em>MPRETURNCODE</em>
 */
MPDLL_EXPORT MPRETURNCODE _stdcall startAcquisition();

/** Stop the acquisition
 *
 *	\return <em>MPRETURNCODE</em>
 */
MPDLL_EXPORT MPRETURNCODE _stdcall stopAcquisition();

/** Get Most Recent Sample
 *
 *	This method blocks until the MP Device acquires the most recent sample. Once startAcquisition() is called, the MP Device continuously acquires data at the specified sample rate. Use this method to get the latest sample collected at the time it was called. This method is useful in monitoring purposes where previous data does not change rapidly.
 *
 *	\param data out variable where the most recent sample for all 16 channels is stored by the function.
 *          If the channel is inactive the corresponding element is not set to a default value.
 *	\note data[<em>i</em>] = the most recent sample of Channel <em>i</em>+1, where 0 &lt;= <em>i</em> &lt; 16
 *	\return <em>MPRETURNCODE</em>
 */
MPDLL_EXPORT MPRETURNCODE _stdcall getMostRecentSample(double *data);

/** Get the acquisition buffer
 *
 *	This method blocks until the MP Device acquires the number of samples requested. It is efficient in memory use. It uses the same memory segment to download the raw data from the MP Device and convert it to actual data. The values will be interleaved, which means that the value for each active channel will be adjacent to each other and in increasing order by channel number.
 *	This function should only be used for acquisitions lasting less than a minute.
 *
 *	\par
 *  \htmlinclude buffer.txt
 *
 *	\param numSamples the number of samples to acquire.
 *	\param buff an out variable where values from the acquisition are stored.  Its must be able to hold at least <em>numSamples*(number of active channels)</em> double values.
 *	\return <em>MPRETURNCODE</em>
 */
MPDLL_EXPORT MPRETURNCODE _stdcall getMPBuffer(DWORD numSamples, double *buff);

/** Set the state of a specific Digital I/O line
 *
 *	<em>true</em> = "high" = 1 = 5.0 volts
 *	\n
 *  <em>false</em> = "low" = 0 = 0.0 volts
 *	\par
 *  This function automatically switches the direction of all the Digital I/O lines to write
 *
 *	\param n the Digital I/O line to set  where 0 &lt;= <em>n</em> &lt; 16
 *	\param state if <em>true</em> the Digital I/O line will be set high, if <em>false</em> it will be set low
 *	\param setnow if <em>true</em> the function will send the setting to the MP Device, if <em>false</em> it will not send settings until the function is called with <em>setnow</em> set to <em>true</em>.  This allows for multiple Digital I/O lines to be configured before they are sent to the MP Device.
 *	\param opt this parameter is ignored unless <em>setnow</em> == <em>true</em>\n
	    if <em>opt</em> == <em>SET_LOW_BITS</em> only digital lines 0-7 are set.\n
	    if <em>opt</em> == <em>SET_HIGH_BITS</em> only digital lines 8-16 are set.\n
 *	\return <em>MPRETURNCODE</em>
 */
MPDLL_EXPORT MPRETURNCODE _stdcall setDigitalIO(DWORD n, BOOL state, BOOL setnow, DIGITALOPT opt);

/** Get the state of a specific Digital I/O line
 *
 *	<em>true</em> = "high" = 1 = 5.0 volts
 *	\n
 *  <em>false</em> = "low" = 0 = 0.0 volts
 *	\par
 *  This function automatically switches the direction of all the Digital I/O lines to read.  Therefore, attempting to read the value of a Digital I/O set via the function call setDigitalIO() will produce inconsistent results.
 *
 *	\param n the Digital I/O to set  where 0 &lt;= <em>n</em> &lt; 16
 *	\param state an out variable where the state of Digital I/O line <em>n</em> is stored.
 *	\param opt
	    if <em>opt</em> == <em>READ_LOW_BITS</em> and 0 &lt;= <em>n</em> &lt; 8 only digital lines 0-7 are read.\n
	    if <em>opt</em> == <em>READ_HIGH_BITS</em> and 8 &lt;= <em>n</em> &lt; 16 only digital lines 8-16 are read.\n
 *	\return <em>MPRETURNCODE</em>
 */
MPDLL_EXPORT MPRETURNCODE _stdcall getDigitalIO(DWORD n, BOOL * state, DIGITALOPT opt);

/** Set Triggering configuration
 *
 *	\note
 *		- By default the triggering is set to off.
 *
 *	\param option different ways to set up triggering must use <em>TRIGGEROPT</em> enumerated values.\n
		if <em>option</em> == <em>MPTRIGOFF</em> the rest of the parameters are ignored by the function. \n
	    if <em>option</em> == <em>MPTRIGEXT</em> the TTL external trigger will be used, parameter <em>posEdge</em> is required and the rest of the parameters are ignored by the function.\n
	    if <em>option</em> == <em>MPTRIGACH</em> one of the analog channel inputs will be used and all the parameters are required by the function.\n
 *	\param posEdge if <em>true</em> the triggering is set for positive edge trigger, if <em>false</em> it is set for negative edge trigger. This parameter is ignored by the function if <em>option</em> is set to <em>MPTRIGOFF</em>.
 *	\param level the voltage level of the trigger, -10 volts &lt;= <em>level</em> &lt;= 10 volts. This parameter is ignored by the function if <em>option</em> is set to <em>MPTRIGOFF</em> or <em>MPTRIGEXT</em>.
 *	\param chNum the  channel where the MP Device waits for the trigger, 0 &lt;= <em>chNum</em> &lt;16. This parameter is ignored by the function if <em>option</em> is set to <em>MPTRIGOFF</em> or <em>MPTRIGEXT</em>.
 *	\return <em>MPRETURNCODE</em>
 */
MPDLL_EXPORT MPRETURNCODE _stdcall setMPTrigger(TRIGGEROPT option, BOOL posEdge, double level, DWORD chNum);

/** Find all MP150s.
 *
 *	Finds all the MP150s routable in the current network configuration and caches their serial numbers which can be read by calling readAvailableMP150SN().
 *
 *	\note
 *		- connectMPDev() must be called first
 *		- the call to connectMPDev() must FAIL because of an invalid serial number
 *		- only works with device type <em>MP150</em> and communication type <em>MPUDP</em>
 *	\return <em>MPRETURNCODE</em>
 */
MPDLL_EXPORT MPRETURNCODE _stdcall findAllMP150();

/** Start the Acquisition Daemon.
 *
 *  Starts a thread (daemon) that downloads the data from the MP unit and caches it once acquisition starts.  The cache can be retrieved by calling receiveMPData().
 *
 *	\note
 *		- call this function first before calling startAcquisition()
 *		- when using this function, you must <b>NOT</b> use any data transfer methods such as, getMPBuffer() and <em>getMPBuffer() functions, during the same acquisition
 *		- the daemon will not exit until the stopAcquisition() or disconnectMPDev() function is called or an error occurs within the thread
 *		- the thread is spawned from the calling process
 *	\return <em>MPRETURNCODE</em>
 */
MPDLL_EXPORT MPRETURNCODE _stdcall startMPAcqDaemon();

/** Receive the MP Data
 *
 *	Receives the MP Data from the MP Acquisition Daemon.
 *
 *	\note
 *		- requires a successful call to startMPAcqDaemon()
 *		- the data will be a stream of double values
 *		- returns <em>MPSUCCESS</em> if it receives 1 or more double values
 *
 *	\htmlinclude stream.txt
 *
 *	\include daemon.txt
 *
 *  \param buff an out variable where the number of requested double values to receive will be stored.  It must be able to hold at least <em>numdatapoints</em> double values
 *	\param numdatapoints the number of values requested to be received from the acquisition daemon
 *	\param numreceived an out variable where the number of double values actually received from the acquisition daemon is stored
 *	\return <em>MPRETURNCODE</em>
 */
MPDLL_EXPORT MPRETURNCODE _stdcall receiveMPData(double * buff, DWORD numdatapoints, DWORD * numreceived);

/** Read the Serial Numbers of Available MP150s
 *
 *	Reads the serial numbers of MP150s routable with the current network configuration.
 *
 *	\note
 *		- requires a successful call to findAllMP150()
 *		- MP150 serial number normally consist of 12 characters
 *		- each line represents the serial number of a MP150
 *		- each line will normally consist of 13 characters (the serial number and the newline character, '\\n')
 *		- returns <em>MPSUCCESS</em> if it reads 1 or more characters
 *
 *	\include readsn.txt
 *
 *	\param buff an out variable where the number of requested character to read will be stored.  It must be able to hold at least <em>numchartoread</em> characters.
 *	\param numchartoread the number of characters requested to be read
 *	\param numcharread an out variable where the number of characters actually read is stored
 *	\return <em>MPRETURNCODE</em>
 */
MPDLL_EXPORT MPRETURNCODE _stdcall readAvailableMP150SN(char * buff, DWORD numchartoread, DWORD * numcharread);

/** Get the MP Daemon Last Error
 *
 *	This method returns the exit value or the status of the MP Acquisition Daemon that was created by a call to startMPAcqDaemon().
 *	This function will block for approximately 750 msec.
 *
 *	\return <em>MPRETURNCODE</em>
 */
MPDLL_EXPORT MPRETURNCODE _stdcall getMPDaemonLastError();

#ifdef __cplusplus
}
#endif

#endif
