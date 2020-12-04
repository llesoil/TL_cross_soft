#!/bin/sh

numb='419'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 1.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.5 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 35 --keyint 250 --lookahead-threads 4 --min-keyint 24 --qp 40 --qpstep 5 --qpmin 2 --qpmax 64 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset medium --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,2.0,1.0,1.1,1.6,0.4,0.9,0.5,2,0,8,35,250,4,24,40,5,2,64,28,4,2000,-2:-2,dia,show,medium,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"