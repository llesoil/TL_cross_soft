#!/bin/sh

numb='1083'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 4.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.8 --aq-mode 0 --b-adapt 1 --bframes 4 --crf 50 --keyint 230 --lookahead-threads 1 --min-keyint 22 --qp 30 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset fast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.1,1.0,4.6,0.5,0.6,0.8,0,1,4,50,230,1,22,30,4,0,60,48,2,2000,-1:-1,umh,show,fast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"