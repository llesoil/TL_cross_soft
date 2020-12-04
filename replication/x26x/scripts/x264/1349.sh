#!/bin/sh

numb='1350'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 2.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.5 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 0 --keyint 300 --lookahead-threads 4 --min-keyint 20 --qp 30 --qpstep 5 --qpmin 0 --qpmax 62 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset veryslow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.1,1.2,2.8,0.4,0.6,0.5,1,2,6,0,300,4,20,30,5,0,62,18,2,1000,-2:-2,dia,crop,veryslow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"