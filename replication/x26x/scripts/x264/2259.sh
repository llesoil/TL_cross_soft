#!/bin/sh

numb='2260'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 4.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.4 --aq-mode 0 --b-adapt 1 --bframes 2 --crf 25 --keyint 300 --lookahead-threads 1 --min-keyint 22 --qp 0 --qpstep 3 --qpmin 4 --qpmax 60 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset placebo --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.0,1.4,1.0,4.2,0.6,0.7,0.4,0,1,2,25,300,1,22,0,3,4,60,18,5,2000,-2:-2,umh,crop,placebo,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"