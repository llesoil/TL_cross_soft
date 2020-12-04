#!/bin/sh

numb='2566'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 3.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 4 --crf 40 --keyint 210 --lookahead-threads 1 --min-keyint 21 --qp 10 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset ultrafast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.5,1.2,3.6,0.3,0.7,0.4,3,2,4,40,210,1,21,10,3,2,67,48,5,1000,-2:-2,umh,show,ultrafast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"