#!/bin/sh

numb='2510'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 4.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 16 --crf 35 --keyint 230 --lookahead-threads 1 --min-keyint 29 --qp 10 --qpstep 4 --qpmin 2 --qpmax 67 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset veryslow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.5,1.3,1.3,4.8,0.2,0.9,0.5,0,2,16,35,230,1,29,10,4,2,67,28,6,2000,-2:-2,umh,crop,veryslow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"