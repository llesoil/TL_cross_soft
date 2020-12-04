#!/bin/sh

numb='1357'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 1.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 16 --crf 5 --keyint 280 --lookahead-threads 3 --min-keyint 25 --qp 20 --qpstep 5 --qpmin 0 --qpmax 61 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset veryslow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.5,1.3,1.4,0.6,0.9,0.2,0,1,16,5,280,3,25,20,5,0,61,28,2,2000,-2:-2,umh,crop,veryslow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"