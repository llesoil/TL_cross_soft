#!/bin/sh

numb='2886'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 1.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.8 --aq-mode 3 --b-adapt 2 --bframes 4 --crf 20 --keyint 270 --lookahead-threads 0 --min-keyint 25 --qp 0 --qpstep 4 --qpmin 3 --qpmax 68 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset veryslow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,0.5,1.0,1.4,1.6,0.4,0.9,0.8,3,2,4,20,270,0,25,0,4,3,68,38,2,1000,-1:-1,umh,show,veryslow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"