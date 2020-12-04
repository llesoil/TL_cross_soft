#!/bin/sh

numb='2462'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 4.6 --qblur 0.4 --qcomp 0.6 --vbv-init 0.9 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 40 --keyint 230 --lookahead-threads 4 --min-keyint 28 --qp 40 --qpstep 4 --qpmin 1 --qpmax 69 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset placebo --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.0,1.1,1.3,4.6,0.4,0.6,0.9,2,2,10,40,230,4,28,40,4,1,69,48,2,2000,-2:-2,umh,show,placebo,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"