#!/bin/sh

numb='47'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 3.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 12 --crf 40 --keyint 200 --lookahead-threads 1 --min-keyint 27 --qp 20 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset placebo --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.5,1.6,1.1,3.6,0.5,0.7,0.7,3,2,12,40,200,1,27,20,3,4,61,48,6,2000,-2:-2,dia,show,placebo,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"