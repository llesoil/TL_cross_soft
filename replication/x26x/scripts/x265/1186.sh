#!/bin/sh

numb='1187'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 5.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 6 --crf 25 --keyint 270 --lookahead-threads 1 --min-keyint 29 --qp 30 --qpstep 5 --qpmin 0 --qpmax 61 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset slow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.2,1.3,5.0,0.3,0.9,0.1,2,1,6,25,270,1,29,30,5,0,61,28,6,2000,-2:-2,umh,crop,slow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"