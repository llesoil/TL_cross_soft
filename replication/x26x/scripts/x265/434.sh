#!/bin/sh

numb='435'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 3.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 25 --keyint 260 --lookahead-threads 4 --min-keyint 23 --qp 20 --qpstep 4 --qpmin 3 --qpmax 61 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset placebo --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.5,1.0,1.3,3.8,0.6,0.6,0.6,0,0,12,25,260,4,23,20,4,3,61,38,5,2000,1:1,umh,crop,placebo,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"