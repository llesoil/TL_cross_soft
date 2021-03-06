#!/bin/sh

numb='2464'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 5.0 --qblur 0.6 --qcomp 0.7 --vbv-init 0.6 --aq-mode 2 --b-adapt 2 --bframes 12 --crf 20 --keyint 290 --lookahead-threads 0 --min-keyint 30 --qp 10 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset veryslow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,0.0,1.0,1.3,5.0,0.6,0.7,0.6,2,2,12,20,290,0,30,10,3,4,61,48,1,2000,1:1,dia,crop,veryslow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"