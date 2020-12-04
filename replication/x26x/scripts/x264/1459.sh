#!/bin/sh

numb='1460'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 0.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 2 --crf 25 --keyint 250 --lookahead-threads 0 --min-keyint 27 --qp 50 --qpstep 3 --qpmin 3 --qpmax 69 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset faster --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.3,1.1,0.2,0.6,0.6,0.7,3,2,2,25,250,0,27,50,3,3,69,48,5,1000,-1:-1,hex,crop,faster,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"