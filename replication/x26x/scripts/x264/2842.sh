#!/bin/sh

numb='2843'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 2.6 --qblur 0.6 --qcomp 0.6 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 45 --keyint 200 --lookahead-threads 2 --min-keyint 22 --qp 20 --qpstep 3 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset medium --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.3,1.0,2.6,0.6,0.6,0.9,2,1,14,45,200,2,22,20,3,4,65,48,3,1000,-2:-2,dia,show,medium,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"