#!/bin/sh

numb='867'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 4.4 --qblur 0.2 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 15 --keyint 200 --lookahead-threads 0 --min-keyint 20 --qp 0 --qpstep 3 --qpmin 0 --qpmax 61 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset placebo --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.0,1.3,1.1,4.4,0.2,0.6,0.1,1,1,12,15,200,0,20,0,3,0,61,48,3,1000,-2:-2,dia,show,placebo,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"