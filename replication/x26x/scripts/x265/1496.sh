#!/bin/sh

numb='1497'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 0.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.8 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 5 --keyint 250 --lookahead-threads 4 --min-keyint 21 --qp 40 --qpstep 5 --qpmin 4 --qpmax 63 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset slow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,2.5,1.2,1.2,0.8,0.2,0.7,0.8,3,2,16,5,250,4,21,40,5,4,63,18,4,1000,1:1,dia,show,slow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"