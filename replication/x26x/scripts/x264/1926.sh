#!/bin/sh

numb='1927'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 1.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 2 --crf 35 --keyint 210 --lookahead-threads 2 --min-keyint 22 --qp 0 --qpstep 4 --qpmin 0 --qpmax 64 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset slower --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.5,1.2,1.0,1.6,0.6,0.9,0.5,3,2,2,35,210,2,22,0,4,0,64,18,3,1000,-2:-2,umh,show,slower,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"