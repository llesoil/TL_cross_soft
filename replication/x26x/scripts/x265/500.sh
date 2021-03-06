#!/bin/sh

numb='501'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 3.6 --qblur 0.6 --qcomp 0.6 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 5 --keyint 290 --lookahead-threads 1 --min-keyint 26 --qp 0 --qpstep 3 --qpmin 2 --qpmax 64 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset slower --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,2.5,1.1,1.1,3.6,0.6,0.6,0.1,0,0,16,5,290,1,26,0,3,2,64,38,4,1000,-2:-2,dia,show,slower,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"