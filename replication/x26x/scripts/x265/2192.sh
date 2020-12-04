#!/bin/sh

numb='2193'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 3.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 0 --keyint 290 --lookahead-threads 0 --min-keyint 20 --qp 20 --qpstep 3 --qpmin 3 --qpmax 69 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset placebo --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.1,1.1,3.6,0.3,0.9,0.1,3,1,14,0,290,0,20,20,3,3,69,28,5,2000,-1:-1,hex,crop,placebo,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"