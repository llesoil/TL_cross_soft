#!/bin/sh

numb='2876'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 4.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.0 --aq-mode 1 --b-adapt 1 --bframes 0 --crf 40 --keyint 250 --lookahead-threads 0 --min-keyint 21 --qp 40 --qpstep 3 --qpmin 0 --qpmax 64 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset veryslow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,0.5,1.0,1.4,4.2,0.5,0.6,0.0,1,1,0,40,250,0,21,40,3,0,64,18,6,1000,1:1,umh,crop,veryslow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"