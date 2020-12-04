#!/bin/sh

numb='6'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 5.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.4 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 30 --keyint 240 --lookahead-threads 4 --min-keyint 26 --qp 10 --qpstep 5 --qpmin 3 --qpmax 66 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset placebo --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.0,1.6,1.3,5.0,0.5,0.6,0.4,2,1,16,30,240,4,26,10,5,3,66,48,4,1000,-2:-2,dia,crop,placebo,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"