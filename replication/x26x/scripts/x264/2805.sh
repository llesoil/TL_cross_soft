#!/bin/sh

numb='2806'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 0.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.8 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 15 --keyint 290 --lookahead-threads 0 --min-keyint 27 --qp 30 --qpstep 3 --qpmin 1 --qpmax 61 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset veryslow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,1.5,1.3,1.3,0.8,0.4,0.9,0.8,0,2,10,15,290,0,27,30,3,1,61,28,1,1000,-2:-2,hex,show,veryslow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"