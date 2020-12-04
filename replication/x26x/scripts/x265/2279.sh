#!/bin/sh

numb='2280'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 1.8 --qblur 0.4 --qcomp 0.8 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 4 --crf 20 --keyint 260 --lookahead-threads 4 --min-keyint 26 --qp 0 --qpstep 4 --qpmin 3 --qpmax 69 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset slower --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.5,1.3,1.4,1.8,0.4,0.8,0.4,3,2,4,20,260,4,26,0,4,3,69,18,5,1000,-2:-2,dia,crop,slower,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"