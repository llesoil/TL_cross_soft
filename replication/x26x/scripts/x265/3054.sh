#!/bin/sh

numb='3055'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 4.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.8 --aq-mode 3 --b-adapt 0 --bframes 8 --crf 5 --keyint 250 --lookahead-threads 4 --min-keyint 29 --qp 50 --qpstep 5 --qpmin 4 --qpmax 62 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset placebo --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.5,1.4,1.2,4.2,0.6,0.6,0.8,3,0,8,5,250,4,29,50,5,4,62,18,5,1000,-1:-1,umh,crop,placebo,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"