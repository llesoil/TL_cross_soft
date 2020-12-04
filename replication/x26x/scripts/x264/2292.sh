#!/bin/sh

numb='2293'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 3.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.7 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 50 --keyint 270 --lookahead-threads 0 --min-keyint 27 --qp 10 --qpstep 5 --qpmin 2 --qpmax 65 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset veryslow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,0.5,1.0,1.3,3.8,0.3,0.7,0.7,0,2,0,50,270,0,27,10,5,2,65,28,5,2000,1:1,dia,crop,veryslow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"