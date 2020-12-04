#!/bin/sh

numb='1366'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 3.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.0 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 15 --keyint 300 --lookahead-threads 0 --min-keyint 28 --qp 20 --qpstep 4 --qpmin 2 --qpmax 63 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset slower --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.0,1.4,1.2,3.4,0.6,0.8,0.0,2,1,14,15,300,0,28,20,4,2,63,48,5,2000,-1:-1,dia,show,slower,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"